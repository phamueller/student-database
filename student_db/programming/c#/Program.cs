using System;
using System.IO;
using MySqlConnector;
using System.Data;

internal class Program
{
    static string user = null;
    static string password = null;
    static string host = null;
    static string port = null;

    private static void readSecret() {
        string file = @"..\secret\pwd.txt";
        string[] lines = File.ReadAllLines(file);

        user = lines[0];
        password = lines[1];

        // Console.WriteLine(user + " " + password);
    }

    private static void readConnection() {
        string file = @"..\secret\host.txt";
        string[] lines = File.ReadAllLines(file);

        host = lines[0];
        port = lines[1]; // not used
        
        // Console.WriteLine(host + " " + port);
    }

    private static void Main(string[] args)
    {
        readSecret();
        readConnection();

        try
        {
            MySqlConnection conn;
            conn = new MySqlConnection("server="+host+";uid="+user+";pwd="+password+";database=student_db");
            string query = "SELECT student_id, student_name, student_number, student_class, student_major FROM student;";

            MySqlCommand cmd = new MySqlCommand(query, conn);
            conn.Open();

            using (MySqlDataReader reader = cmd.ExecuteReader())
            {
                Console.WriteLine(" student_id, student_name, student_number, student_class, student_major");
                while (reader.Read())
                {
                    Console.WriteLine(" " + reader[0].ToString() + ", " + reader[1].ToString() + ", " + reader[2].ToString() + ", " + reader[3].ToString() + ", " + reader[4].ToString());
                }
            }
        }
        catch (MySql.Data.MySqlClient.MySqlException ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}