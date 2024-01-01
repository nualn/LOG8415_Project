
#!/bin/bash

bench_public=$1

# Install Sysbench on the benchmark host
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@${bench_public} << EOF
# Update the system packages
sudo apt-get update
# Install Sysbench
sudo apt-get install -y sysbench
exit
EOF