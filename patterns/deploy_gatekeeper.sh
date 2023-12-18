#!/bin/bash

# Store the server address from the input parameter
server_addr=$1
proxy_addr=$2

# Copy the gatekeeper program to the remote server using SCP
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./gatekeeper.py ubuntu@$server_addr:gatekeeper.py

# SSH into the remote server and execute commands to run the gatekeeper
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ec2-user@$server_addr << EOF
    sudo apt-get update
    sudo apt-get -y install python3
    pip3 install flask

    echo "$proxy_addr" > proxy_addr

    python3 gatekeeper.py

    exit
EOF