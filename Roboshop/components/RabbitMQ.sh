#!/usr/bin/env bash

source components/common.sh
checkRootUser

ECHO "Configuring Erlang YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG_FILE}
statusCheck $?

ECHO "Configuring RabbitMQ YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
statusCheck $?

ECHO  "Install Erlang & RabbitMQ"
yum install erlang rabbitmq-server -y  &>>${LOG_FILE}
statusCheck $?

ECHO  "Enable RabbitMQ Server"
systemctl enable rabbitmq-server  &>>${LOG_FILE}
statusCheck $?

ECHO  "Start RabbitMQ Server"
systemctl start rabbitmq-server  &>>${LOG_FILE}
statusCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Create an Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  statusCheck $?
fi

ECHO "Setup Application User Persmissions"
rabbitmqctl set_user_tags roboshop administrator  &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG_FILE}
statusCheck $?