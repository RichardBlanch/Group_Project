#!/usr/bin/python
# -*- coding: utf-8 -*-

import MySQLdb as mdb

con = mdb.connect('localhost', 'root', 'password', 'classDatabase.sql');

with con: 

    cur = con.cursor()
    cur.execute("SELECT * FROM classDatabase.sql")

    rows = cur.fetchall()

    for row in rows:
        print row
