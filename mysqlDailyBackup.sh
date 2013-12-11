#!/bin/bash
# Name:mysqlDailyBackup.sh
# MySQL DataBase Daily Backup.
# Last Modify:2013-12-08
#
# /etc/mysql/my.cnf 打开log-bin选项
# 创建$dataDir
# 需创建/tmp/mysqlbackup/daily目录
# 设置email 
# 设置mysql 用户名密码
scriptsDir=`pwd`
MYSQLADMIN="$(which mysqladmin)"
# binlog direction
dataDir=/var/log/mysql
MYSQLUSER=root
MYSQLUSERPWD=123456
dataBackupDir=/tmp/mysqlbackup
dailyBackupDir=$dataBackupDir/daily
eMailFile=$dataBackupDir/email.txt
eMail=howiefh@gmail.com
logFile=$dataBackupDir/mysqlbackup.log
HOSTNAME=`uname -n`
#
echo "" > $eMailFile
echo $(date +"%y-%m-%d %H:%M:%S") >> $eMailFile
#
# $mysqlDir/bin/mysqladmin -u$MYSQLUSER -p$MYSQLUSERPWD flush-logs
$MYSQLADMIN -u$MYSQLUSER -p$MYSQLUSERPWD flush-logs
cd $dataDir
fileList=`cat mysql-bin.index`
iCounter=0
for file in $fileList
do
  iCounter=`expr $iCounter + 1`
done
nextNum=0
iFile=0
for file in $fileList
do
  binLogName=`basename $file`
  nextNum=`expr $nextNum + 1`
  if [[ $nextNum == $iCounter ]]; then
    echo "Skip lastest!" > /dev/null
  else
    dest=$dailyBackupDir/$binLogName
    if [[ -e $dest ]]; then
      echo "Skip exist $binLogName!" > /dev/null
    else
      cp $binLogName $dailyBackupDir
      if [[ $? == 0 ]]; then
        iFile=`expr $iFile + 1`
        echo "$binLogName Backup Success!" >> $eMailFile
      fi
    fi
  fi
done
if [[ $iFile == 0 ]];then
  echo "No Binlog Backup!" >> $eMailFile
else
  echo "Backup $iFile File(s)." >> $eMailFile
  echo "Backup MySQL Binlog OK!" >> $eMailFile
# Move Backup Files To Backup Server.
  $scriptsDir/rsyncBackup.sh
  if [[ $? == 0 ]]; then
    echo "Move Backup Files To Backup Server Success!" >> $eMailFile
  else
    echo "Move Backup Files To Backup Server Fail!" >> $eMailFile
  fi
fi
cat $eMailFile | mail -s "MySQL Backup" $eMail
echo "--------------------------------------------------------" >> $logFile
cat $eMailFile >> $logFile

