#!/usr/bin/python3

# execute the script on Linux
# >./python.py

# Import
import sys
import mysql.connector

gv_username = "hans"            # gv_ = global variable
gv_password = "kennwort"
gf_password = "../secret/pwd"    # gf_ = file name
gv_database = "student_db"
gv_host = "31.214.242.135"

# Function for reading secrets
def fct_reading_secrets():
    global gv_username, gv_password

    f = open(gf_password, "r")
    lines = f.readlines()
    gv_username = lines[0]
    gv_password = lines[1]
    f.close()

fct_reading_secrets()

# Debugging: Printing secrets
#sys.stdout.write('username: ' + gv_username + "\n")
#sys.stdout.write('password: ' + gv_password + "\n")

mysql_conn = mysql.connector.connect(
  user = gv_username,
  password = gv_password,
  host = gv_host,
  port = 3306,
  database = gv_database
)

cursor = mysql_conn.cursor()
cursor.execute("SELECT * FROM student;")

resultset = cursor.fetchall()

for result in resultset:
  sys.stdout.write(result + "\n")

