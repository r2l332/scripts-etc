#!/usr/bin/env python
from linode_auto_deploy import ipAdd
import base64, sys
from dyn.tm.session import *
from dyn.tm.zones import *
from dyn.tm.errors import *
##################################
#         dynDns Updater
#   By Lee Jelley November 2016
#    *******MIT License*******
#        .py 3 of 3 files
##################################
dname = None
# This Variable should be called from customer when entering company name.
cust = base64.b64decode(None)
user = base64.b64decode(None)
passwd = base64.b64decode(None)
# Create New session function

def newSession():
    try:
        session = DynectSession(cust,user,passwd)
    except DynectAuthError, a:
        err = "ERR! {}".format(a)
        with open('failedToAuthenticate.log', 'w') as log:
            log.write(err + '\n')

def createARecord():
    try:
        # Select Zone from where to add new A record
        my_zone = Zone('fileserverapp.com')
        zone_token = my_zone.get_node(dname)
        if zone_token == dname:
            print "Zone already in use"
            sys.exit()
        else:
        # Add new A record to Zone
        a_rec = my_zone.add_record(dname, 'A', address=ipAdd)
        my_zone.publish()
    except DynectCreateError, b:
        err = "ERR! {}".format(b)
        with open('failedToCreate.log', 'w') as log1:
            log1.write(err + '\n')

newSession()
createARecord()
