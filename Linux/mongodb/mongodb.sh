#! /bin/bash  #Ensures the script runs with the correct shell

sudo su
mv ./mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y 
systemctl enable mongod 
systemctl start mongod 

vi /etc/mongod.conf
sed s/127.0.0.1 /0.0.0.0 /g mongod.conf
systemctl restart mongod