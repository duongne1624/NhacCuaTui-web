using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data.SqlClient;
using System.Web.Mvc;
using System.Data;

namespace NhacCuaTui.Models
{
    public class DataModel
    {
        private string connectionString = "";
        
        public ArrayList get(String sql)
        {
            ArrayList datalist = new ArrayList();

            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(sql, connection);
            connection.Open();
            using (SqlDataReader r = command.ExecuteReader())
            {
                while (r.Read())
                {
                    ArrayList row = new ArrayList();
                    for (int i = 0; i < r.FieldCount; i++)
                    {
                        row.Add(r.GetValue(i).ToString());
                    }
                    datalist.Add(row);
                }
            }
            connection.Close();
            return datalist;
        }

        public object getScalar(string sql)
        {
            object result = null;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                try
                {
                    connection.Open();
                    result = command.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error executing scalar query: " + ex.Message);
                }
                finally
                {
                    connection.Close();
                }
            }

            return result;
        }


        public ArrayList getAPI(String sql)
        {
            ArrayList datalist = new ArrayList();
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(sql, connection);
            connection.Open();
            using (SqlDataReader r = command.ExecuteReader())
            {
                while (r.Read())
                {
                    ArrayList row = new ArrayList();
                    for (int i = 0; i < r.FieldCount; i++)
                    {
                        row.Add(xulydulieu(r.GetValue(i).ToString()));
                    }
                    datalist.Add(row);
                }
            }
            connection.Close();
            return datalist;
        }
        public string xulydulieu(string text)
        {
            String s = text.Replace(",", "&44;");
            s = s.Replace("\"", "&34;");
            s = s.Replace("'", "&39;");
            s = s.Replace("\r", "");
            s = s.Replace("\n", "\n");
            return s;
        }

        public Dictionary<string, ArrayList> getAllAPI(string sql)
        {
            Dictionary<string, ArrayList> allData = new Dictionary<string, ArrayList>();
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(sql, connection);

            connection.Open();
            using (SqlDataReader reader = command.ExecuteReader())
            {
                int tableIndex = 0;
                string tableName = "";
                do
                {
                    ArrayList tableData = new ArrayList();
                    switch (tableIndex)
                    {
                        case 0:
                            tableName = "Users";
                            break;
                        case 1:
                            tableName = "Genres";
                            break;
                        case 2:
                            tableName = "Artists";
                            break;
                        case 3:
                            tableName = "Albums";
                            break;
                        case 4:
                            tableName = "Songs";
                            break;
                        case 5:
                            tableName = "SongArtists";
                            break;
                        case 6:
                            tableName = "Playlists";
                            break;
                        case 7:
                            tableName = "PlaylistSongs";
                            break;
                        case 8:
                            tableName = "Comments";
                            break;
                    }
                    while (reader.Read())
                    {
                        ArrayList row = new ArrayList();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row.Add(xulydulieu(reader.GetValue(i).ToString()));
                        }
                        tableData.Add(row);
                    }
                    allData.Add($"{tableName}", tableData);
                    tableIndex++;

                } while (reader.NextResult());
            }

            connection.Close();
            return allData;
        }
    }
}