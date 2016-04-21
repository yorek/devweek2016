using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace DatabaseHammer
{
    public class SparseTestType : ITestType
    {
        private SqlCommand _cmd;
        private SqlConnection _conn;

        public string Description
        {
            get { return "Sparse"; }
        }
        
        private SqlCommand GenerateSqlCommand(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes)
        {
                SqlCommand cmd = new SqlCommand("dbo.stp_insert_custom_product_data_sparse", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = int.MaxValue;

                SqlParameter pName = cmd.Parameters.Add("@product_name", SqlDbType.VarChar, 100);
                pName.Value = "Product_" + taskNum.ToString();

                SqlParameter pCustomData = cmd.Parameters.Add("@product_custom_data", System.Data.SqlDbType.Xml);
                pCustomData.Value = GenerateParamValue(taskNum, usedAttributes);                   
                
                return cmd;            
        }
    
        private object GenerateParamValue(int taskNum, List<CustomAttribute> usedAttributes)
        {
            Random rnd = new Random(taskNum);
            StringBuilder sb = new StringBuilder();

            foreach (CustomAttribute ca in usedAttributes)
            {
                switch (ca.DataType)
                {
                    case "D":
                        sb.AppendFormat("<{0}>{1}</{0}>", ca.Name, DateTime.Now.AddDays(-200 + rnd.Next(100)).ToString("yyyyMMdd"));
                        break;
                    case "T":
                        sb.AppendFormat("<{0}>{1}</{0}>", ca.Name, DateTime.Now.AddSeconds(-20000 + rnd.Next(10000)).ToString("hh:mm:ss"));
                        break;
                    case "N":
                        sb.AppendFormat("<{0}>{1}</{0}>", ca.Name, rnd.Next(0, 1000000));
                        break;
                    case "S":
                        int r = rnd.Next(1, 4);
                        if (r < 2)
                        {
                            sb.AppendFormat("<{0}>{1}</{0}>", ca.Name, "Test" + rnd.Next(0, 100).ToString());
                        }
                        break;
                }
            }

            return sb.ToString();
        }

        public void InititalizeRun(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes)
        {
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
                SqlCommand cmd = new SqlCommand("TRUNCATE TABLE dbo.products; TRUNCATE TABLE dbo.products_custom_data_sparse", conn);
                cmd.CommandType = CommandType.Text;
                cmd.ExecuteNonQuery();
            }
        }

        public void CheckResult(SqlConnection conn)
        {
            using (conn)
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(DISTINCT product_id) FROM dbo.products_custom_data_sparse", conn);
                cmd.CommandType = CommandType.Text;
                int insertedRows = (int)cmd.ExecuteScalar();
                Console.WriteLine("Inserted products: {0}", insertedRows);
            }
        }
    }
}
