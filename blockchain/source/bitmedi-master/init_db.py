#!/usr/bin/python                                                               
                                                                                
import sqlite3                                                                  
                                                                                
conn = sqlite3.connect('cached.db')                                             
                                                                                
print "Opened database successfully"                                            
                                                                                
conn.execute('''CREATE TABLE CACHED                                             
       (USERID 		VCAHR(50) NOT NULL,                              
       ENTRYHASHED      CHAR(64)  NOT NULL);                              
       ''')
conn.execute("CREATE INDEX index1 ON cached (USERID);")

print "Table created successfully"                                              
                                                                                
conn.close()
