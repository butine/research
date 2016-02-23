#!/usr/bin/python

import sqlite3                                                                  
                                                                                
conn = sqlite3.connect('cached.db')                                             
                                                                                
print "Opened database successfully"                                            
                                                                                
for i in conn.execute("select count(*) from cached"):               
	print i

                                                                                
conn.close()
