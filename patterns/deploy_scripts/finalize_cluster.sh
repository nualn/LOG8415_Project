#!/bin/bash

proxy_ip=$(python3 -m address_getters.get_private_ip_proxy)
mngr_public=$1

ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$mngr_public << EOF
sudo /opt/mysqlcluster/home/mysqlc/bin/mysqld --defaults-file=/opt/mysqlcluster/deploy/conf/my.cnf --user=root &
sleep 20
exit
EOF

ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$mngr_public << EOF
sudo apt-get install unzip
exit
EOF

ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$mngr_public << EOF
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql
CREATE USER 'test'@'${proxy_ip}' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'${proxy_ip}';
exit

wget https://downloads.mysql.com/docs/sakila-db.zip
unzip -o sakila-db.zip -d sakila

sudo /opt/mysqlcluster/home/mysqlc/bin/mysql
SOURCE /home/ubuntu/sakila/sakila-db/sakila-schema.sql;
SOURCE /home/ubuntu/sakila/sakila-db/sakila-data.sql;
USE sakila;
exit

sudo /opt/mysqlcluster/home/mysqlc/bin/ndb_mgm -e show

exit 
EOF
