#!/bin/bash

# Get the public and internal DNS addresses of the cluster using Python scripts
public_dns=($(python3 -m address_getters.get_public_dns_cluster))
internal_dns=($(python3 -m address_getters.get_internal_dns_cluster))

# Assign the first public and internal DNS addresses to the manager node
mngr_public=${public_dns[0]}
mngr_internal=${internal_dns[0]}

# Assign the next public DNS addresses to the other nodes
node1_public=${public_dns[1]}
node2_public=${public_dns[2]}
node3_public=${public_dns[3]}

# Deploy the manager node using its public DNS and all internal DNS addresses
./deploy_scripts/deploy_mngr.sh $mngr_public ${internal_dns[@]}

# Deploy the other nodes using their public DNS and the manager's internal DNS
./deploy_scripts/deploy_node.sh $node1_public $mngr_internal
./deploy_scripts/deploy_node.sh $node2_public $mngr_internal
./deploy_scripts/deploy_node.sh $node3_public $mngr_internal

# Finalize the cluster deployment using the manager's public DNS
./deploy_scripts/finalize_cluster.sh $mngr_public

# Output the internal DNS addresses of all nodes in JSON format and save it to a file
echo "{
    \"manager_addr\": \"$mngr_internal\",
    \"node1_addr\": \"${internal_dns[1]}\",
    \"node2_addr\": \"${internal_dns[2]}\",
    \"node3_addr\": \"${internal_dns[3]}\"
}" > ./data/cluster_info.json