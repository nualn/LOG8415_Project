from python_lib.instances import Instances
from python_lib.utils import save_dict_to_file

"""
This script is used to set up a cluster of instances on AWS. 
It creates a security group, a key pair, and launches instances for the MySQL cluster, proxy, and gatekeeper. 
After launching, it waits for all instances to be running. 
Finally, it writes the AWS resource info (instance IDs, security group, and key) to files.
"""

if __name__ == "__main__":
    cluster_instances = Instances()
    vpc_id = cluster_instances.get_vpc_id()
    cluster_instances.create_security_group(vpc_id, allow_ssh=True)
    cluster_instances.create_key_pair()

    # launch instances for the mysql cluster
    cluster_security_groups = ["default",
                               cluster_instances.security_group["name"]]
    cluster_instances.launch_n_instances(
        4, "t2.micro", cluster_security_groups)

    # launch instances for the proxy
    proxy_instances = Instances(
        key=cluster_instances.key, security_group=cluster_instances.security_group)
    proxy_instances.launch_n_instances(
        1, "t2.large", cluster_security_groups)

    # launch instances for the gatekeeper
    gatekeeper_instances = Instances(key=cluster_instances.key)
    gatekeeper_instances.create_security_group(
        vpc_id, allow_ssh=True, allow_http=True)
    gatekeeper_security_groups = ["default",
                                  gatekeeper_instances.security_group["name"]]
    gatekeeper_instances.launch_n_instances(
        1, "t2.large", gatekeeper_security_groups)

    # wait for instances to be running
    cluster_instances.wait_for_instances_running()
    proxy_instances.wait_for_instances_running()
    gatekeeper_instances.wait_for_instances_running()

    # write aws resource info to files
    cluster_data = {
        "instance_ids": cluster_instances.instance_ids,
        "security_group": cluster_instances.security_group,
        "key": cluster_instances.key,
    }
    proxy_data = {
        "instance_ids": proxy_instances.instance_ids,
        "security_group": proxy_instances.security_group,
        "key": proxy_instances.key,
    }
    gatekeeper_data = {
        "instance_ids": gatekeeper_instances.instance_ids,
        "security_group": gatekeeper_instances.security_group,
        "key": gatekeeper_instances.key,
    }

    save_dict_to_file(cluster_data, './data/cluster_resources.json')
    save_dict_to_file(proxy_data, './data/proxy_resources.json')
    save_dict_to_file(gatekeeper_data, './data/gatekeeper_resources.json')

    # write key to file
    key_file = open("./data/key.pem", "w")
    key_file.write(cluster_instances.key["KeyMaterial"])
    key_file.close()
