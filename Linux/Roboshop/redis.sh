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

dnf module disable redis -y
Validate $? "disable redis"
dnf module enable redis:7 -y
Validate $? "enable redis"

dnf install redis -y 
Validate $? "redis install"

sed -i 's/127.0.0.1 /0.0.0.0 /g' /etc/redis/redis.conf

sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf

systemctl enable redis
Validate $? "enable redis"
systemctl start redis 
Validate $? "start redis"