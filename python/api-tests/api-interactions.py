#!/usr/bin/env python
import base64, requests, re, os, sys
from requests_toolbelt.multipart.encoder import MultipartEncoder
from datetime import datetime
###
# API Upload/download checker v0.1
#             By Lee Jelley
###
dtime = datetime.now().strftime('%Y%m%d_%H:%M- ')
info = ['https://<URL>', base64.b64encode(None),
        base64.b64encode(None), base64.b64encode(None),
        base64.b64decode(None), base64.b64encode(str(None)),
        None]
'''
The list called 'info' contains the following info in respective order;
url, username, password, foldername, folder_path, download_file_id, download_filename
'''
payload = info[1]+','+info[2]
# User creds payload
payload2 = info[3]+',,,,MA==,eQ=='
# ^^ Folder details payload

def authApi():
    try:
        go = requests.get(info[0]+'*/gettoken/'+payload).text
        grab = go.strip().split()
        for line in grab:
            if re.search('<token>', line):
                token = line[7:-8]
                return token

    except requests.exceptions.HTTPError, a:
        err = "ERR! {}".format(b)
        with open('http_error.log', 'w') as log:
            log.write(dtime + err + '\n')

def uploadFile(token):
    try:
        newStatus = ''
        fl_id = ''
        go = requests.get(info[0]+token+'/doCreateNewFolder/'+payload2).text
        status = go.strip().split()
        for stat in status:
            if re.search('<status>', stat):
                newStatus = stat[8:-9]
                for flid in status:
                    if re.search('<fi_id>', flid):
                        fl_id = base64.b64encode(flid[7:-8])
                        fl2_id = base64.b64decode(fl_id)

            if newStatus == 'ok':
                print "Successfully created folder!"
                print "Uploading file to '%s'!" % base64.b64decode(info[3])
                m = MultipartEncoder(
                    fields={
                            'fi_pid' : fl2_id,
                            'fi_structuretype' : 'g',
                            'file_name1' : 'test_upload.txt',
                            'file_1' : ('test_upload.txt', open('test_upload.txt', 'rb'), 'text/plain')
                            })
                folderUpload = requests.post(info[0]+token+'/doUploadFiles/', data=m, headers={'Content-Type': m.content_type})
                print "Upload Successful!"
                break
            elif newStatus == 'error_already_exists':
                print "Uploading to '%s' folder" % base64.b64decode(info[3])
                #dlt = requests.get(url+token+'/doDeleteFolder/'+fl_id)
                m = MultipartEncoder(
                    fields={
                            'fi_pid' : fl2_id,
                            'fi_structuretype' : 'g',
                            'file_name1' : 'test_upload.txt',
                            'file_1' : ('test_upload.txt', open('test_upload.txt', 'rb'), 'text/plain')
                            })
                rootUpload = requests.post(info[0]+token+'/doUploadFiles/', data=m, headers={'Content-Type': m.content_type})
                print "Upload Successful!"
                break

    except requests.exceptions.ConnectionError, b:
        err = "ERR! {}".format(b)
        with open('connection.log', 'w') as log1:
            log1.write(dtime + err + '\n')

def downloadFile(token):
    try:
        print "Preparing to download file..."
        with open('downloadFile', 'w') as dwnld:
            dwn = requests.get(info[0]+token+'/getFile/'+info[5]+',').text
            dwnld.write(dwn)

        dwnldFile = os.listdir('.')
        for dwn in dwnldFile:
            if dwn == info[6]:
                print 'Download Successful ... Removing file'
                os.remove(info[6])
                hasGone = os.listdir('.')
                if hasGone != info[6]:
                    print 'File removed!'
                    break
                else:
                    print "File still exists, I haven't done my job correctly!"
                    break
            #elif dwn != info[6]:
            #    print "File does not exist in local path... Something went wrong!"
            #    break

    except requests.exceptions.ConnectionError, c:
        err = "ERR! {}".format(c)
        with open('download.log', 'w') as log2:
            log2.write(dtime + err + '\n')

token = authApi()
uploadFile(token)
downloadFile(token)
