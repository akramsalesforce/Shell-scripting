source components/common.sh

CHECK_ROOT

Print "Configure YUM Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
StatCheck $?

Print "Install MongoDB"
yum install -y mongodb-org &>>${LOG_FILE}
StatCheck $?

Print "Configure MongoDB Service"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

Print "Start MonogDB"
systemctl enable mongod &>>${LOG_FILE}  && systemctl restart mongod &>>${LOG_FILE}
StatCheck $?


Print "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
StatCheck $?

Print "Load Schema"
cd mongodb-main
#for schema in catalogue users; do
for schema in catalogue ; do
  echo "Load $schema Schema"
  mongo < ${schema}.js &>>$LOG_FILE
  StatCheck $?
done