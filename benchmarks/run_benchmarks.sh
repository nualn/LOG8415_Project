#!/bin/bash

bench_public=$1
single_public=$2
mngr_public=$3

ssh -oStrictHostKeyChecking=no -tt -i ./data/key.pem ubuntu@${bench_public} << EOF
# Benchmark single node
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} prepare
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} run > res_single.txt
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${single_public} cleanup

# Benchmark cluster
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster prepare
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster run > res_cluster.txt
sudo sysbench oltp_read_write --table-size=100000 --db-driver=mysql --mysql-db=sakila --mysql-user=test --mysql-password=test --mysql-host=${mngr_public} --mysql_storage_engine=ndbcluster cleanup

#Print results
echo "Single node results:"
cat res_single.txt
echo "======================================"
echo "Cluster results:"
cat res_cluster.txt

exit
EOF