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

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip 
cd /app 
unzip /tmp/cart.zip >>$logfile
Validate $? "unzip"

npm install >>$logfile
Validate $? "dependencies addition"



cp $scriptdir/cart.service  /etc/systemd/system/cart.service >>$logfile

systemctl daemon-reload

systemctl enable cart 
Validate $? "cart enable"
systemctl start cart >>$logfile
Validate $? "cart start"
