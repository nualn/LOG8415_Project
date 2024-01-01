#!/bin/bash

bench_public=$1
single_public=$2
mngr_public=$3

# Start an SSH session with the benchmark server
ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@${bench_public} << EOF

# Benchmark single node
# Prepare the database for benchmarking
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} prepare

# Run the benchmark and save the results to a file
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} run > res_single.txt

# Cleanup the database after benchmarking
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} cleanup


# Benchmark cluster
# Prepare the database for benchmarking
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster prepare

# Run the benchmark and save the results to a file
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster run > res_cluster.txt

# Cleanup the database after benchmarking
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster cleanup

# Print results
echo "Single node results:"
cat res_single.txt
echo "======================================"
echo "Cluster results:"
cat res_cluster.txt

exit
EOF