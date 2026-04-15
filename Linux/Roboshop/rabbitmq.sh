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

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo >> $logfile
Validate $? "Copying mongodb"

dnf install rabbitmq-server -y >> $logfile
Validate $? "rabbitmq installation"

systemctl enable rabbitmq-server --no-pager --quiet # no pager will remove the green colour for enabled in status message"
Validate $? "enabled rabbitmq"
systemctl start rabbitmq-server
Validate $? "started rabbitmq"

rabbitmqctl add_user roboshop roboshop123 >> $logfile
Validate $? "user add"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >> $logfile
Validate $? "user permissions"