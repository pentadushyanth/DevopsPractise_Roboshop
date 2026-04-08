#! /bin/bash  #Ensures the script runs with the correct shell

mkdir -p /var/log
logfile="/var/log/logfile.log"
Validate() {
if [ $? -eq 0 ]
then 
    echo "success"
    exit 0
else
    echo "failed" 
    exit 1
fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo >> $logfile
Validate $?

dnf install mongodb-org -y >> $logfile
Validate $?
systemctl enable mongod 
Validate $?
systemctl start mongod 
Validate $?
sed 's/127.0.0.1 /0.0.0.0 /g' /etc/mongod.conf
Validate $?

systemctl restart mongod