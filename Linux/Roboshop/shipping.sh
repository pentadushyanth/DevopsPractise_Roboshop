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


dnf install maven -y >>$logfile
Validate $? "maven installation"

id roboshop
if [ $? -ne 0 ];then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop >>$logfile
    Validate $? "user added"
else
    echo -e "user already exists hence skipping"
fi

cd /app
if [ $? -eq 0 ];then
    rm -rf /app/*
else
    mkdir /app     
fi

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
cd /app 
unzip /tmp/shipping.zip >>$logfile
Validate $? "unzip"

cd /app 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 


cp $scriptdir/shipping.service  /etc/systemd/system/shipping.service >>$logfile

systemctl daemon-reload

systemctl enable shipping 
Validate $? "shipping enable"
systemctl start shipping >>$logfile
Validate $? "shipping start"

dnf install mysql -y  >>$logfile
Validate $? "mysql installation"

mysql -h $mysqlip -uroot -pRoboShop@1 < /app/db/schema.sql >>$logfile
mysql -h $mysqlip -uroot -pRoboShop@1 < /app/db/app-user.sql >>$logfile
mysql -h $mysqlip -uroot -pRoboShop@1 < /app/db/master-data.sql >>$logfile

systemctl restart shipping
