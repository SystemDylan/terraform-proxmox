import os
import mysql.connector

# Read environment variables
mysql_host = os.environ['MYSQL_HOST']
mysql_user = os.environ['MYSQL_USER']
mysql_password = os.environ['MYSQL_PASSWORD']

# Connect to MySQL
cnx = mysql.connector.connect(user=mysql_user, password=mysql_password, host=mysql_host)
cursor = cnx.cursor()

# Create database and table
cursor.execute("CREATE DATABASE IF NOT EXISTS my_database1")
cursor.execute("USE my_database1")
cursor.execute("""
CREATE TABLE IF NOT EXISTS fortunes (
  id CHAR(3) PRIMARY KEY,
  fortune TEXT NOT NULL
)
""")

# Define the fortune data
data = [
    ("f1", "The greatest joy in life is doing what others say you cannot do."),
    ("f2", "The key to happiness is to find joy in the journey, not just the destination."),
    ("f3", "Success is not final, failure is not fatal: it is the courage to continue that counts"),
    ("f4", "The road to success is always under construction."),
    ("f5", "Your greatest asset is your positive attitude."),
    ("f6", "Eat, Sleep, Repeat"),
    ("f7", "Accomplishments are transient"),
    ("f8", "You will encounter many defeats in your life, but you must not be defeated."),
    ("f9", "Be the change you wish to see in the world."),
    ("f10", "A journey of a thousand miles begins with a single step."),
]

# Insert data into the table
for item in data:
    cursor.execute("INSERT INTO fortunes (id, fortune) VALUES (%s, %s) ON DUPLICATE KEY UPDATE fortune = VALUES(fortune)", item)

# Commit changes and close the connection
cnx.commit()
cursor.close()
cnx.close()
