using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace DatabaseHammer
{
    public interface ITestType
    {
        string Description { get; }
        
        /// <summary>
        /// Initialize Test.
        /// Executed only once, before test run
        /// </summary>
        /// <param name="conn"></param>
        
        void InititalizeTest(SqlConnection conn);       
        /// <summary>
        /// Execute test. Executed as much as needed by different threads.
        /// </summary>
        /// <param name="taskNum"></param>
        /// <param name="conn"></param>
        /// <param name="usedAttributes"></param>
        
        void InititalizeRun(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes);
        
        void Run();
        
        void CheckResult(SqlConnection conn);
    }
}
