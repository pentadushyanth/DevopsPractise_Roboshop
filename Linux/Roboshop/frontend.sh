#! /bin/bash

mkdir -p /var/log
logfile="/var/log/logfile.log"
scriptdir=$PWD
mysqlip=mysql.practisedevops.shop
Validate() {
if [ $1 -eq 0 ];
then 
    echo "$2 is success"
else
    echo "$2 is failed" 
    exit 1
fi
}

dnf module disable nginx -y >>$logfile
Validate $? "nginx disable"

dnf module enable nginx:1.24 -y >>$logfile
Validate $? "nginx enable"

rm -rf /etc/nginx/nginx.conf/* &>>$logfile
VALIDATE $? "removed nginx content"


dnf install nginx -y >>$logfile
Validate $? "nginx installation"

systemctl enable nginx >>$logfile
Validate $? "nginx enable"
systemctl start nginx >>$logfile
Validate $? "nginx start"

rm -rf /usr/share/nginx/html/* 
Validate $? "content removed"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip >>$logfile
Validate $? "unzip success"

cp $scriptdir/nginx.conf  /etc/nginx/nginx.conf >>$logfile
Validate $? "configuration copied"

systemctl restart nginx 
Validate $? "nginx restarted"





