#!/bin/bash

public_dns=($(python3 -m get_public_dns))
internal_dns=($(python3 -m get_internal_dns))
internal_ips=($(python3 -m get_internal_ips))

# Cluster deployment variables
mngr_public=${public_dns[0]}
mngr_internal=${internal_dns[0]}
node1_public=${public_dns[1]}
node2_public=${public_dns[2]}
node3_public=${public_dns[3]}

# Single node deployment variables
single_public=${public_dns[4]}

# Benchmark host
bench_public_dns=${public_dns[5]}
bench_private_dns=${internal_dns[5]}
bench_private_ip=${internal_ips[5]}
 
# Deploy cluster
./deploy_mngr.sh $mngr_public ${internal_dns[@]}
./deploy_node.sh $node1_public $mngr_internal
./deploy_node.sh $node2_public $mngr_internal
./deploy_node.sh $node3_public $mngr_internal
./finalize_cluster.sh $mngr_public $bench_private_ip

# Deploy single node
./deploy_single.sh $single_public $bench_private_dns

# Deploy benchmark host
./deploy_benchmarker.sh $bench_public_dns

echo "$bench_public_dns $single_public $mngr_public" > ./data/bench_args.txt
