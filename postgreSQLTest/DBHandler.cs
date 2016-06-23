using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;
using System.Data;

namespace postgreSQLTest
{
    public class DBHandler
    {
        string connString = string.Empty;

        public DBHandler(string connectionString)
        {
            connString = connectionString;
        }

        public bool ExecuteNonQuery(string query)
        {
            int affectedRows = 0;

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();

                using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                {
                    cmd.CommandTimeout = 1000;
                    affectedRows = cmd.ExecuteNonQuery();
                }

                con.Close();
            }

            if (affectedRows > 0)
                return true;

            return false;     
        }

        public bool IsItemExists(string query)
        {
            NpgsqlDataReader dr;

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();

                using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                {
                    cmd.CommandTimeout = 1000;
                    dr = cmd.ExecuteReader();
                }

                con.Close();
            }

            if (dr.HasRows)
                return true;

            return false;
        }

        public DataTable GetDataTable(string query)
        {
            DataTable dt = new DataTable();

            using (NpgsqlDataAdapter adp = new NpgsqlDataAdapter(query, connString))
            {
                adp.Fill(dt);
            }

            return dt;
        }
    }
}
