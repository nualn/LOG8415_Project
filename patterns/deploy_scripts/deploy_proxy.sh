#!/bin/bash

# Store the server address from the input parameter
server_addr=$(python3 -m address_gettrs/get_public_dns_proxy)

# Copy the proxy program to the remote server using SCP
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./flask_apps/proxy.py ubuntu@$server_addr:proxy.py
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./data/cluster_info.json ubuntu@$server_addr:cluster_info.json

# SSH into the remote server and execute commands to run the proxy
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$server_addr << EOF
    sudo apt-get update
    sudo apt-get -y install python3-pip
    sudo pip3 install flask
    sudo pip3 install pymysql

    sudo nohup python3 proxy.py &

    curl -X POST -H "Content-Type: text/plain" -d "SELECT * FROM actor LIMIT 3;" http://localhost/direct_hit
    exit
EOF