#!/bin/bash

#######
# DB dump for ddb
# Dumps database schema minus the data
# By Lee Jelley 2016
#######


echo "Dumping DB Database schema to DDB DB database"

function dumpDb() {

mysqldump -h 'localhost' -u ddb_script_user --password='password' --force --add-drop-table --no-data database | mysql -u ddb_script_user --password='password' database

}

sleep 1

echo "Dumping DB Database schema to DDB DB database"

function dumpDb2() {

mysqldump -h 'localhost' -u ddb_script_user --password='password' --force --add-drop-table --no-data database | mysql -u ddb_script_user --password='password' database

}

dumpDb >& /var/log/dbdump.log
dumpDb2 >& /var/log/db2dump.log
