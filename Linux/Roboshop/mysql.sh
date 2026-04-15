#! /bin/bash

mkdir -p /var/log
logfile="/var/log/logfile.log"
Validate() {
if [ $1 -eq 0 ];
then 
    echo "$2 is success"
else
    echo "$2 is failed" 
    exit 1
fi
}


dnf install mysql-server -y >> $logfile
Validate $? "mysql installation"
systemctl enable mysqld --no-pager --quiet # no pager will remove the green colour for enabled in status message"
Validate $? "enabled mysqld"
systemctl start mysqld 
Validate $? "started mysqld"

mysql_secure_installation --set-root-pass RoboShop@1
Validate $? "password changed"

systemctl restart mysqld
Validate $? "restart"