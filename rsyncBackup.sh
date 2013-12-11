#!/bin/bash
# Name:rsyncBackup.sh
# Move Backup Files To Backup Server.
# Last Modify:2013-12-08
#
#ftp配置
ftphost=localhost
ftpport=21
#用户名
ftpuser=testuser
#密码
ftppwd=1234
#这个就是FTP根目录下的data文件夹，表示就保存在这里
ftpdir=pub
dataBackupDir=/tmp/mysqlbackup/
#
#开始连接远程ftp
#http://rzl01.blog.51cto.com/3004337/579529
sss=`find $dataBackupDir -type d -printf $ftpdir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'` 
aaa=`find $dataBackupDir -type f -printf 'put %p %P \n'` 
ftp -nv $ftphost <<EOF 
user $ftpuser $ftppwd
type binary 
prompt 
$sss 
cd $ftpdir
$aaa 
quit 
EOF
