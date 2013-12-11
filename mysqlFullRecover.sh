#!/bin/bash
# Name:mysqlFullRecover.sh
# MySQL DataBase Full Recover
# Last Modify:2013-12-08

# 设置mysql 用户名密码
# 设置数据库名
# usage: ./mysqlFullRecover.sh mysql.sql
MYSQLUSER=root
MYSQLUSERPWD=123456
DBName=test
MYSQL="$(which mysql)"
$MYSQL -u$MYSQLUSER -p$MYSQLUSERPWD $DBName< $1
