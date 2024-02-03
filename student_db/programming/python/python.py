#!/usr/bin/python3

# execute the script on Linux
# >./python.py

# Import
import sys
import mysql.connector

gv_username    = "user"                  # gv_ = global variable 
gv_password    = "kennwort"
gv_host        = "connection"
gf_password    = "../secret/pwd"         # gf_ = global file 
gf_host        = "../secret/host"
gv_database    = "student_db"
gv_host        = "127.0.0.1"
gv_port        = "1234"

# Function for reading secrets
def fct_reading_secret():
    global gv_username, gv_password

    f = open(gf_password, "r")
    lines = f.readlines()
    gv_username = lines[0]
    gv_password = lines[1]
    f.close()

def fct_reading_host():
    global gv_host

    f = open(gf_host, "r")
    lines = f.readlines()
    gv_host = lines[0]
    gv_port = lines[1]
    f.close()

fct_reading_secret()
fct_reading_host()

# Debugging: Printing secrets
#sys.stdout.write('username: ' + gv_username + "\n")
#sys.stdout.write('password: ' + gv_password + "\n")

mysql_conn = mysql.connector.connect(
  user = gv_username,
  password = gv_password,
  host = gv_host,
  port = gv_port,
  database = gv_database
)

cursor = mysql_conn.cursor()
cursor.execute("SELECT student_id, student_name, student_number, student_class, student_major FROM student;")

resultset = cursor.fetchall()

for result in resultset:
  sys.stdout.write(result + "\n")

