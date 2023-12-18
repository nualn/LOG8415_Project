#!/bin/bash

# Store the server address from the input parameter
server_addr=$1

# Copy the proxy program to the remote server using SCP
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./proxy.py ubuntu@$server_addr:proxy.py
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./data/cluster_info.json ubuntu@$server_addr:cluster_info.json

# SSH into the remote server and execute commands to run the proxy
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ec2-user@$server_addr << EOF
    sudo apt-get update
    sudo apt-get -y install python3
    pip3 install flask

    python3 proxy.py

    exit
EOF