#!/bin/bash

public_dns=($(python3 -m address_getters.get_public_dns_cluster))
internal_dns=($(python3 -m address_getters.get_internal_dns_cluster))

# Cluster deployment variables
mngr_public=${public_dns[0]}
mngr_internal=${internal_dns[0]}
node1_public=${public_dns[1]}
node2_public=${public_dns[2]}
node3_public=${public_dns[3]}

# Deploy cluster
./deploy_scripts/deploy_mngr.sh $mngr_public ${internal_dns[@]}
./deploy_scripts/deploy_node.sh $node1_public $mngr_internal
./deploy_scripts/deploy_node.sh $node2_public $mngr_internal
./deploy_scripts/deploy_node.sh $node3_public $mngr_internal
./deploy_scripts/finalize_cluster.sh $mngr_public

echo "{
    \"manager_addr\": \"$mngr_internal\",
    \"node1_addr\": \"${internal_dns[1]}\",
    \"node2_addr\": \"${internal_dns[2]}\",
    \"node3_addr\": \"${internal_dns[3]}\"
}" > ./data/cluster_info.json
