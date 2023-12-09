#!/bin/bash

source components/common.sh


Print "Setup MongoDB Yum repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
StatCheck $?

#curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo


Print "Installing MongoDB"
yum install -y mongodb-org  &>>${LOG_FILE}
StatCheck $?

Print "Configure Listen Address in MonogBD Configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

Print "Start MongoDB Service"
systemctl restart mongod &>>${LOG_FILE} && systemctl enable mongod >>${LOG_FILE}
StatCheck $?

Print "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"  >>${LOG_FILE}
StatCheck $?

Print "Extract Schema Zip"
cd /tmp && unzip -o mongodb.zip >>${LOG_FILE}
StatCheck $?

cd mongodb-main
Print "Load Schema example"
for component in catalogue users ; do
mongo < ${component}.js >>${LOG_FILE}
done
StatCheck $?