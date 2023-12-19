#!/bin/bash

# Store the server address from the input parameter
server_addr=$(python3 -m address_getters.get_public_dns_gatekeeper)
proxy_addr=$(python3 -m address_getters.get_private_dns_proxy)

# Copy the gatekeeper program to the remote server using SCP
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./flask_apps/gatekeeper.py ubuntu@$server_addr:gatekeeper.py

# SSH into the remote server and execute commands to run the gatekeeper
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$server_addr << EOF
    sudo apt-get update
    sudo apt-get -y install python3-pip
    exit
EOF

ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$server_addr << EOF
    sudo pip3 install flask

    echo "$proxy_addr" > proxy_addr

    sudo nohup python3 gatekeeper.py &

    curl -X POST http://localhost/process_request -H "Content-Type: text/plain" -d "SELECT * FROM actor LIMIT 3;"

    exit
EOF