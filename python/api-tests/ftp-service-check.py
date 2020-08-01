#!/usr/bin/env python
import ftplib
from datetime import datetime
from ftplib import FTP
import os
##############################
# ftp upload/download test
# by Lee Jelley 2016
##############################

usern = None
pwd = None
conn = FTP(None)
dtime = datetime.now().strftime('%Y%m%d_%H:%M:%S - ')
dwnf = None
# ^^ A file that already exists on the ftp server.
ERROR = open('err.log', 'w')
ERROR.close()
fn = 'err.log'

def createConn():
    try:
        access = conn.login(user=usern,passwd=pwd)
        if access == 230:
            return access
    except ftplib.all_errors, e:
        err = "ERR! {}".format(e)
        with open('connectionError.log', 'a') as log:
            log.write(dtime + err + '\n')

def sendFile():
    try:
        chngpth = conn.cwd(None)
        # ^^ Change to a path that already exists.
        with open('err.log', 'r') as t:
            upld = conn.storlines('STOR '+ fn, t)
            t.close()
            aTest = conn.nlst()
            if aTest[2] == fn:
                print "Upload Successful!"
            elif aTest[2] < fn:
                print "Upload Failed!"
            conn.delete('err.log')
    except ftplib.all_errors, a:
        err = "ERR! {}".format(a)
        with open('upLoad.log', 'a') as l:
            l.write(dtime + err + '\n')

def downFile():
    try:
        chngpth = conn.cwd(None)
        # ^^ Change to a directory that already exists and contains download file.
        with open(dwnf, 'w') as f:
            getFile = conn.retrlines('RETR '+dwnf, f.write)
    except ftplib.all_errors, c:
        err = "ERR! {}".format(c)
        with open('downLoad.log', 'a') as lg:
            lg.write(dtime + err + '\n')
    try:
        lst = os.listdir('.')
        for i in lst:
            if i == 'downloadFile':
                print "Upload and Download completed Successfully!"
            elif i < 'downloadFile':
                print "Download Unsuccessful!"
    except os.error, ll:
        print "Err:", ll

createConn()
sendFile()
downFile()
