#!/bin/bash

# Get the public DNS address of the gatekeeper server using a Python script
server_addr=$(python3 -m address_getters.get_public_dns_gatekeeper)

# Get the private DNS address of the proxy server using a Python script
proxy_addr=$(python3 -m address_getters.get_private_dns_proxy)

# Copy the gatekeeper program to the remote server using SCP
# The -oStrictHostKeyChecking=no option allows the script to connect to the server without manual confirmation
# The -i option specifies the path to the private key file
scp -oStrictHostKeyChecking=no -i ./data/key.pem ./flask_apps/gatekeeper.py ubuntu@$server_addr:gatekeeper.py

# SSH into the remote server and execute commands to update the package list and install pip for Python 3
# This is done in a separate SSH session because the version of ubuntu used by the server sometimes hangs after installing packages
# When this happens, the separate SSH session can be closed with Ctrl+C and the script will resume. 
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$server_addr << EOF
    sudo apt-get update
    sudo apt-get -y install python3-pip
    exit
EOF

# SSH into the remote server again and execute commands to install Flask, run the gatekeeper program, and send a test request
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@$server_addr << EOF
    sudo pip3 install flask

    # Write the proxy address to a file
    echo "$proxy_addr" > proxy_addr

    # Run the gatekeeper program in the background
    sudo nohup python3 gatekeeper.py &

    # Send a test request to the gatekeeper
    curl -X POST http://localhost/process_request -H "Content-Type: text/plain" -d "SELECT * FROM actor LIMIT 3;"

    exit
EOF