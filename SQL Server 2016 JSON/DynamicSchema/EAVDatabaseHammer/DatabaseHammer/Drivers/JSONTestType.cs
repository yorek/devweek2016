using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Bson;

namespace DatabaseHammer
{
    public class JSONTestType : ITestType
    {
        private SqlCommand _cmd;
        private SqlConnection _conn;
        private int _taskNum;

        public string Description
        {
            get { return "JSON (Blob, Check)"; }
        }

        private SqlCommand GenerateSqlCommand(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes)
        {
            SqlCommand cmd = new SqlCommand("dbo.stp_insert_custom_product_data_json", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = int.MaxValue;

            SqlParameter pName = cmd.Parameters.Add("@product_name", SqlDbType.VarChar, 100);
            pName.Value = "Product_" + taskNum.ToString();

            SqlParameter pCustomData = cmd.Parameters.Add("@product_custom_data", System.Data.SqlDbType.NVarChar, -1);
            pCustomData.Value = GenerateParamValue(taskNum, usedAttributes);

            return cmd;
        }

        private string GenerateParamValue(int taskNum, List<CustomAttribute> usedAttributes)
        {
            JObject payload = new JObject();
            Random rnd = new Random(taskNum);

            foreach (CustomAttribute ca in usedAttributes)
            {
                switch (ca.DataType)
                {
                    case "D":
                        payload.Add(ca.Name, DateTime.Now.AddDays(-200 + rnd.Next(100)).ToString("yyyyMMdd"));
                        break;
                    case "T":
                        payload.Add(ca.Name, DateTime.Now.AddSeconds(-20000 + rnd.Next(10000)).ToString("hh:mm:ss"));                        
                        break;
                    case "N":
                        payload.Add(ca.Name, rnd.Next(0, 1000000));                      
                        break;
                    case "S":
                        int r = rnd.Next(1, 4);
                        if (r < 2)
                        {
                            payload.Add(ca.Name, "Test" + rnd.Next(0, 100).ToString());                           
                        }
                        break;
                }
            }

            return payload.ToString();
        }

        public void InititalizeRun(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes)
        {
            _taskNum = taskNum;
            _conn = conn;
            _cmd = GenerateSqlCommand(taskNum, _conn, usedAttributes);
        }

        public void Run()
        {
            _conn.Open();
            _cmd.ExecuteNonQuery(); 
            _conn.Close();
        }

        public void InititalizeTest(SqlConnection conn)
        {
            using (conn)
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("TRUNCATE TABLE dbo.products; TRUNCATE TABLE dbo.products_custom_data_json", conn);
                cmd.CommandType = CommandType.Text;
                cmd.ExecuteNonQuery();
            }
        }

        public void CheckResult(SqlConnection conn)
        {
            using (conn)
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(DISTINCT product_id) FROM dbo.products_custom_data_json", conn);
                cmd.CommandType = CommandType.Text;
                int insertedRows = (int)cmd.ExecuteScalar();
                Console.WriteLine("Inserted products: {0}", insertedRows);
            }
        }
    } 
}
