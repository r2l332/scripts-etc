#!/usr/bin/env python
from linode import *
##################################
#   Image Auto Deploy *autoDisk*
#   By Lee Jelley November 2016
#    *******MIT License*******
#        .py 1 of 3 files
##################################
# VARS
key = Api(None)
# ^^ Enter API key here - SME Linode API KEY
linodeTmp = None
# ^^ Enter Linode template name here - This should be taken from customer company name.
####################
# Location Variables
####################
Dallas = 2
Fremont = 3
Atlanta = 4
Newark = 6
London = 7
Tokyo = 8
Singapore = 9
Frankfurt = 10
# ^ This information should be taken from customer signup
#################
# Price PlanID
#################
twenty = 2
forty = 4
eighty = 6
# ^ This information should be taken from customer signup
##################

print "Welcome to SME's autoDisk mover, please note this process can take some time..."

def build_linode_tmp():
    build = key.linode.create(DatacenterID=None,PlanID=None)
    # ^^ Add DCID and PLANID variables

def list_linodes():
    ls = key.linode.list()
    for vm in ls:
        if vm['STATUS'] == -1 or vm['STATUS'] == 0:
            linID = vm['LINODEID']
            return linID

def lin_update(linID):
    update = key.linode.update(LinodeID=linID,Label=linodeTmp)

build_linode_tmp()
linID = list_linodes()
lin_update(linID)
