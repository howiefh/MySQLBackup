#!/bin/bash
# Name:mysqlFullBackup.sh
# MySQL DataBase Full Backup.
# Last Modify:2013-12-08
#
# Use mysqldump --help get more detail.
#
# 需创建/tem/mysqlbackup目录
# 设置email 
# 设置mysql 用户名密码
# 数据库名

scriptsDir=`pwd`
MYSQLDUMP="$(which mysqldump)"
MYSQLUSER=root
MYSQLUSERPWD=123456
dataBackupDir=/tmp/mysqlbackup
eMailFile=$dataBackupDir/email.txt
eMail=howiefh@gmail.com
logFile=$dataBackupDir/mysqlbackup.log
DBName=test
DATE=`date -I`

echo "" > $eMailFile
echo $(date +"%y-%m-%d %H:%M:%S") > $eMailFile
cd $dataBackupDir
dumpFile=${DBName}_${DATE}.sql
GZDumpFile=${DBName}_${DATE}.sql.tar.gz

$MYSQLDUMP -u$MYSQLUSER -p$MYSQLUSERPWD \
--opt --default-character-set=utf8 \
$DBName > $dumpFile

if [[ $? == 0 ]]; then
  tar czf $GZDumpFile $dumpFile >> $eMailFile 2>&1
  echo "BackupFileName:$GZDumpFile" >> $eMailFile
  echo "DataBase Backup Success!" >> $eMailFile
  rm -f $dumpFile

# Delete daily backup files.
  cd $dataBackupDir/daily
  rm -f *

# Delete old backup files(mtime>2).
  $scriptsDir/rmBackup.sh

# Move Backup Files To Backup Server.
  $scriptsDir/rsyncBackup.sh 
    if (( !$? )); then
      echo "Move Backup Files To Backup Server Success!" >> $eMailFile
    else
      echo "Move Backup Files To Backup Server Fail!" >> $eMailFile
    fi

else
  echo "DataBase Backup Fail!" >> $emailFile
fi

echo "--------------------------------------------------------" >> $logFile
cat $eMailFile >> $logFile
cat $eMailFile | mail -s "MySQL Backup" $eMail
