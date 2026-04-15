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

dnf install python3 gcc python3-devel -y >>$logfile
Validate $? "python installation"

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

curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
cd /app 
unzip /tmp/payment.zip >>$logfile
Validate $? "unzip"

cd /app 
pip3 install -r requirements.txt >>$logfile
Validate $? "requirements install"

cp $scriptdir/payment.service  /etc/systemd/system/payment.service >>$logfile

systemctl daemon-reload

systemctl enable payment 
Validate $? "payment enable"
systemctl start payment >>$logfile
Validate $? "payment start"



