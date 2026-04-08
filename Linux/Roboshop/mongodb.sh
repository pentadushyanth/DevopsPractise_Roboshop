#! /bin/bash  #Ensures the script runs with the correct shell

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
cp mongo.repo /etc/yum.repos.d/mongo.repo >> $logfile
Validate $? "Copying mongodb"

dnf install mongodb-org -y >> $logfile
Validate $? "mongodb installation"
systemctl enable mongod 
Validate $? "enabled mongodb"
systemctl start mongod 
Validate $? "started mongodb"

sed -i 's/127.0.0.1 /0.0.0.0 /g' /etc/mongod.conf
Validate $? "IP update"

systemctl restart mongod
Validate $? "restart"