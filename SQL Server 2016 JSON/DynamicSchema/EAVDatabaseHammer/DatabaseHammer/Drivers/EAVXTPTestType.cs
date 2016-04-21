using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace DatabaseHammer
{
    public class EAVXTPTestType : ITestType
    {
        private SqlCommand _cmd;
        private SqlConnection _conn;

        public string Description
        {
            get { return "EAV (XTP)"; }
        }

        private SqlCommand GenerateSqlCommand(int taskNum, SqlConnection conn, List<CustomAttribute> usedAttributes)
        {
                SqlCommand cmd = new SqlCommand("dbo.stp_insert_custom_product_data_eav_xtp", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = int.MaxValue;

                SqlParameter pName = cmd.Parameters.Add("@product_name", SqlDbType.VarChar, 100);
                pName.Value = "Product_" + taskNum.ToString();

                SqlParameter pCustomData = cmd.Parameters.Add("@product_custom_data", System.Data.SqlDbType.Structured);
                pCustomData.TypeName = "dbo.eav_payload_type_xtp";
                pCustomData.Value = GenerateParamValue(taskNum, usedAttributes);                   
                
                return cmd;            
        }
    
        private object GenerateParamValue(int taskNum, List<CustomAttribute> usedAttributes)
        {
            Random rnd = new Random(taskNum);
            DataTable dt = new DataTable(); 
            dt.Columns.Add("attribute_id", typeof(int));
            dt.Columns.Add("numeric_value", typeof(decimal));
            dt.Columns.Add("string_value", typeof(string));
            dt.Columns.Add("date_value", typeof(DateTime));
            dt.Columns.Add("time_value", typeof(DateTime));

            foreach (CustomAttribute ca in usedAttributes)
            {
                DataRow dr = null;

                switch (ca.DataType)
                {
                    case "D":
                        dr = dt.NewRow();
                        dr["attribute_id"] = ca.Id;
                        dr["date_value"] = DateTime.Now.AddDays(-200 + rnd.Next(100));
                        break;
                    case "T":
                        dr = dt.NewRow();
                        dr["attribute_id"] = ca.Id;
                        dr["time_value"] = DateTime.Now.AddSeconds(-20000 + rnd.Next(10000));
                        break;
                    case "N":
                        dr = dt.NewRow();
                        dr["attribute_id"] = ca.Id;
                        dr["numeric_value"] = rnd.Next(0, 1000000);
                        break;
                    case "S":
                        int r = rnd.Next(1, 4);
                        if (r < 2)
                        {
                            dr = dt.NewRow();
                            dr["attribute_id"] = ca.Id;
                            dr["string_value"] = "Test" + rnd.Next(0, 100).ToString();
                        }
                        break;
                }

                if (dr != null)
                { 
                    dt.Rows.Add(dr);
                }
            }

            return dt;
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
                SqlCommand cmd = new SqlCommand("DELETE FROM dbo.products_xtp; DELETE FROM dbo.products_custom_data_eav_xtp", conn);
                cmd.CommandType = CommandType.Text;
                cmd.ExecuteNonQuery();
            }
        }

        public void CheckResult(SqlConnection conn)
        {
            using (conn)
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(DISTINCT product_id) FROM dbo.products_custom_data_eav_xtp", conn);
                cmd.CommandType = CommandType.Text;
                int insertedRows = (int)cmd.ExecuteScalar();
                Console.WriteLine("Inserted products: {0}", insertedRows);
            }
        }
    }
}
