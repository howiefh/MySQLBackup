#!/bin/bash
# Name:rmBackup.sh
# Delete old Backup.
# Last Modify:2013-12-08
#
dataBackupDir=/tmp/mysqlbackup
DBName=test
find $dataBackupDir -name "${DBName}_*.gz" -type f -mtime +2 -exec rm {} \; > /dev/null 2>&1

