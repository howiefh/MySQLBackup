## 定时执行
设置crontab任务，每天执行备份脚本
shell> crontab -e
```
#每个星期日凌晨3:00执行完全备份脚本
0 3 * * 0 /root/MySQLBackup/mysqlFullBackup.sh >/dev/null 2>&1
#周一到周六凌晨3:00做增量备份
0 3 * * 1-6 /root/MySQLBackup/mysqlDailyBackup.sh >/dev/null 2>&1
```

## 恢复
mysqlFullRecover.sh 最后一次备份的sql
mysqlDailyRecover.sh  本周的二进制日志文件

