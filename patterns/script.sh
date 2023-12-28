#!/bin/bash

setup() {
    echo "Executing environment setup..."
    python3 setup.py
    ./deploy_all.sh
}

example_request() {
    echo "Making request..."
    gatekeeper_address=$(./address_getters/get_public_dns_gatekeeper.py)
    curl -X POST http://$gatekeeper_address/process_request -H "Content-Type: text/plain" -d "SELECT * FROM actor LIMIT 3;"
}

teardown() {
    echo "Terminating environment..."
    python3 teardown.py
}

case "$1" in
    "setup")
        setup
        ;;
    "teardown")
        teardown
        ;; 
    "example_request")
        example_request
        ;;
esac


