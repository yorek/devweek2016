using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Configuration;
using System.Reflection;
using System.Data;

namespace DatabaseHammer
{
    public class CustomAttribute
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string DataType { get; set; }
    }   

    public class TestInfo       
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public Type AssemblyType { get; set; }
    }

    class Program
    {
        private static int _taskNumber = 32;
        private static int _sleepTime = 20;
        private static string _connectionString = "";
        private static List<CustomAttribute> _customAttributes = new List<CustomAttribute>();

        private static long[] _minElapsed;
        private static long[] _maxElapsed;

        static void Main(string[] args)
        {
            Console.WriteLine("EAV Demo DatabaseHammer {0} (c) Davide Mauri 2011-2016", Assembly.GetExecutingAssembly().GetName().Version);
            Console.WriteLine("To be used only for demo purposes. Use at your own risk.");
            Console.WriteLine("NOTE: Requires SQL Server 2016 at least.");
            Console.WriteLine("Licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 2.5 Italy License.");
            Console.WriteLine();

            Console.WriteLine("Loading configuration...");
            _connectionString = ConfigurationManager.ConnectionStrings["default"].ConnectionString;
            _taskNumber = Properties.Settings.Default.TaskNumber;
            _sleepTime = Properties.Settings.Default.SleepTime;

            Console.WriteLine("Task Number: " + _taskNumber.ToString());
            Console.WriteLine("Sleep Time: " + _sleepTime.ToString());
            Console.WriteLine();

            _maxElapsed = new long[_taskNumber+1];
            _minElapsed = new long[_taskNumber+1];           

            Console.WriteLine("Loading tests...");
            List<TestInfo> avalTests = new List<TestInfo>();
            int tn = 0;
            foreach(Type t in Assembly.GetExecutingAssembly().GetTypes().OrderBy(x => x.Name))
            {
                if (t.GetInterfaces().Contains(typeof(ITestType)) && t.GetConstructor(Type.EmptyTypes) != null)
                {
                    ITestType tt = Activator.CreateInstance(t) as ITestType;

                    TestInfo ti = new TestInfo() { Id = tn, Description = tt.Description, AssemblyType = t };                   
                    avalTests.Add(ti);

                    Console.WriteLine(tt.Description + " - " + t.FullName);
                    tn++;
                }
            }
            Console.WriteLine();
            
            Console.WriteLine("Loading database metadata...");
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("SELECT attribute_id, name, datatype FROM dbo.custom_attributes", conn);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    CustomAttribute ca = new CustomAttribute() { Id = dr.GetInt32(0), Name = dr.GetString(1), DataType = dr.GetString(2) };
                    _customAttributes.Add(ca);
                }
                dr.Close();
            }
            Console.WriteLine("{0} custom attributes loaded.", _customAttributes.Count);
            if (_customAttributes.Count == 0)
            {
                Console.WriteLine("No custom attributes found!. Application terminated.");
#if DEBUG
                Console.ReadLine();
#endif
                return;
            }
            Console.WriteLine();

            Console.WriteLine("Done.");
            Console.WriteLine();

            while (true)
            {
                TestInfo selectedTest = null;

                Console.WriteLine("Available Tests:");
                foreach (TestInfo ti in avalTests)
                {                    
                    Console.WriteLine("[{0}] {1}", ti.Id, ti.Description);
                }
                Console.WriteLine("Select the test to run. Then press 'c' to cancel.");

                bool waitForKey = true;
                bool quit = false;
                while (waitForKey)
                {
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    string c = k.KeyChar.ToString().ToLower();
                    if (c == "c") 
                    {
                            quit = true;
                            waitForKey = false;
                            break;
                    }

                    int tc = 0;
                    if (int.TryParse(c, out tc) == true)
                    {
                        selectedTest = avalTests[tc];
                        break;
                    }
                }

                if (quit) return;

                Console.WriteLine("Starting Test Type: " + selectedTest.Description);

                Console.WriteLine("Cleaning tables used in Test...");
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    ITestType testType = (ITestType)Activator.CreateInstance(selectedTest.AssemblyType);
                    testType.InititalizeTest(conn);
                }

                Console.WriteLine("Creating test tasks...");
                var tokenSource = new CancellationTokenSource();
                var token = tokenSource.Token;

                for (int t = 0; t < _taskNumber; t++)
                {
                    _minElapsed[t] = -1;
                    _maxElapsed[t] = -1;
                }

                Task[] tasks = new Task[_taskNumber];
                bool createTask = true;

                Console.WriteLine("Running Test...");
                if (createTask == true)
                {
                    for (int t = 0; t < _taskNumber; t++)
                    {
                        Task newTask = Task.Factory.StartNew(() => RunHammer(t, selectedTest.AssemblyType, token), TaskCreationOptions.LongRunning);
                        tasks[t] = newTask;
                    }
                    createTask = false;
                }

                Console.WriteLine("Now waiting for 10 seconds...");
                Thread.Sleep(10000);
                Console.WriteLine("Done...");

                tokenSource.Cancel();
                Console.WriteLine("Sending task cancellation...");

                try
                {
                    Task.WaitAll(tasks);
                }
                catch (AggregateException e)
                {
                    // For demonstration purposes, show the OCE message.
                    foreach (var v in e.InnerExceptions)
                        Console.WriteLine("OCE Message: " + v.Message);
                }

                // Cleanup Tasks.
                for (int i = 0; i < tasks.Length; i++)
                {
                    if (tasks[i].Status == TaskStatus.Faulted) { 
                        Console.WriteLine("[{0}] status is now {1}", i + 1, tasks[i].Status);
                    }
                    tasks[i].Dispose();
                }

                Console.WriteLine("Done.");

                // Allow the tasks to be created again
                createTask = true;
                tokenSource = new CancellationTokenSource();
                token = tokenSource.Token;

                Console.WriteLine("Results:");
                long totMinElapsed = 0;
                long totMaxElapsed = 0;
                for (int i = 0; i < _taskNumber; i++)
                {
                    // Console.WriteLine("{0}: {1}, {2}", i, _minElapsed[i], _maxElapsed[i]);
                    if (_minElapsed[i] > -1 && _maxElapsed[i] > -1)
                    {
                        if (totMinElapsed > _minElapsed[i]) totMinElapsed = _minElapsed[i];
                        if (totMaxElapsed < _maxElapsed[i]) totMaxElapsed = _maxElapsed[i];
                    }
                }
                Console.WriteLine("Task Performance (Min/Max): {0}/{1}", totMinElapsed, totMaxElapsed);

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    ITestType testType = (ITestType)Activator.CreateInstance(selectedTest.AssemblyType);
                    testType.CheckResult(conn);
                }

                Console.WriteLine("Done.");
                Console.WriteLine();
            }
        }

        private static void RunHammer(int taskNum, Type assemblyTestType, CancellationToken ct)
        {
            long minElapsed = 0;
            long maxElapsed = 0;

            // Was cancellation already requested?
            if (ct.IsCancellationRequested)
            {              
                ct.ThrowIfCancellationRequested();
            }

            ITestType testType = (ITestType)Activator.CreateInstance(assemblyTestType);

            using (SqlConnection conn = new SqlConnection(_connectionString + "Application Name = EAV Database Hammer Task "  + taskNum.ToString()))
            {
                Random rnd = new Random(taskNum);
                int attributeCount = _customAttributes.Count;

                while (true)
                {
                    int maxAttributesToUse = rnd.Next(1, attributeCount);

                    // Extract random attributes to use
                    List<CustomAttribute> usedAttributes = new List<CustomAttribute>();
                    for (int c = 0; c < maxAttributesToUse; c++ )
                    {
                        int p = rnd.Next(1, attributeCount);
                        CustomAttribute rndAttribute = _customAttributes[p];

                        if (!usedAttributes.Contains(rndAttribute))
                        {
                            usedAttributes.Add(rndAttribute);
                        }
                    }

                    // Initialize test run
                    testType.InititalizeRun(taskNum, conn, usedAttributes);

                    // Run
                    Stopwatch sw = new Stopwatch();                    
                    sw.Start();
                    try
                    {
                        testType.Run();
                    } catch(Exception e)
                    {
                        Console.WriteLine("Exception trapped: " + e.Message);
                        throw e;
                    }
                    sw.Stop();

                    if (sw.ElapsedMilliseconds < minElapsed) minElapsed = sw.ElapsedMilliseconds;
                    if (sw.ElapsedMilliseconds > maxElapsed) maxElapsed = sw.ElapsedMilliseconds;

                    // Sleep
                    Thread.Sleep(_sleepTime);

                    if (ct.IsCancellationRequested) break;
                }                
            }
            _minElapsed[taskNum] = minElapsed;
            _maxElapsed[taskNum] = maxElapsed;
        }        
    }
}
