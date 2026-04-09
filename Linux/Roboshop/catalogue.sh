#! /bin/bash  #Ensures the script runs with the correct shell

mkdir -p /var/log
logfile="/var/log/logfile.log"
scriptdir=$PWD
mongoserverip=mongodb.practisedevops.shop
Validate() {
if [ $1 -eq 0 ];
then 
    echo "$2 is success"
else
    echo "$2 is failed" 
    exit 1
fi
}

dnf module disable nodejs -y >>$logfile
Validate $? "nodejs disable"

dnf module enable nodejs:20 -y >>$logfile
Validate $? "nodejs enable"

dnf install nodejs -y >>$logfile
Validate $? "nodejs installation"

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

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip >>$logfile
Validate $? "unzip"

npm outdated
npm install >>$logfile
Validate $? "dependencies addition"



cp $scriptdir/catalogue.service  /etc/systemd/system/catalogue.service >>$logfile

systemctl daemon-reload

systemctl enable catalogue 
Validate $? "catalogue enable"
systemctl start catalogue >>$logfile
Validate $? "catalogue start"

cp $scriptdir/mongo.repo /etc/yum.repos.d/mongo.repo
Validate $? "repo copied"

dnf install mongodb-mongosh -y >>$logfile
Validate $? "mongosh install"

mongosh --host $mongoserverip</app/db/master-data.js >>$logfile
Validate $? "master data loaded"

