#!/usr/bin/env python
from linode import *
import time
from linode_build import linID, key, linodeTmp
##################################
#   Image Auto Deploy *autoDisk*
#   By Lee Jelley November 2016
#    *******MIT License*******
#        .py 2 of 3 files
##################################

start = timeone.time()
imageTmp = None
# ^^ Insert Image name into the above variable - Golden SAAS image

def find_disk():
    lsDisk = key.image.list()
    for mv in lsDisk:
        if mv['LABEL'] == imageTmp:
            # ^^ Looks for name of disk image
            diskID = mv['IMAGEID']
            return diskID
            # ^^ Returns Image ID variable

def deploy_disk(diskID):
    deployDsk = key.linode.disk.createfromimage(ImageID=diskID,
                                                LinodeID=linID)
    # ^^ Creates new disk from 'Golden' image
    deployDskId = deployDsk['DISKID']
    deployDskJb = deployDsk['JOBID']
    deploySwap = key.linode.disk.create(LinodeID=linID,
                                        Label='swap',
                                        Type='swap',
                                        Size=256)
    deploySwapId = deploySwap['DiskID']
    # ^^ Creates new SWAP disk and assigns it to Linode template
    deployCfg = key.linode.config.create(LinodeID=linID,
                                        Label=linodeTmp,
                                        KernelID=138,
                                        DiskList=[deployDskId,deploySwapId])
    deployJbCk = key.linode.job.list(LinodeID=linID,JobID=deployDskJb)
    #deployJbNw = deployJbCk['HOST_FINISH_DT']
    #while deployJbNw != '':
    #    return deployJbLn

    bootLinode = key.linode.boot(LinodeID=linID)
    # ^^ Boots Linode
    ipId = key.linode.ip.list(LinodeID=linID)
    for ip in ipId:
        ipAdd = ip['IPADDRESS']
        print """Disk Move complete, thanks for using autoDisk!"""
        print """You're IP Address is""", ipAdd
        print """This script took""", int(time.time()-start), """seconds to run."""
        return ipAdd

diskID = find_disk()
ipAdd = deploy_disk(diskID)
