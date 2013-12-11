#!/bin/bash
# Name:mysqlDailyRecover.sh
# MySQL DataBase Daily Recover
# Last Modify:2013-12-08
#
# /etc/mysql/my.cnf 打开log-bin选项
# 设置mysql 用户名密码
# 设置数据库名
# usage: ./mysqlDailyRecover.sh mysql-bin.000001 mysql-bin.000002 
MYSQLUSER=root
MYSQLUSERPWD=123456
MYSQLBINLOG="$(which mysqlbinlog)"
MYSQL="$(which mysql)"
$MYSQLBINLOG $@ | $MYSQL -u$MYSQLUSER -p$MYSQLUSERPWD
