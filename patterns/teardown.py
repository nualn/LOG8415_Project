
from python_lib.instances import Instances
from python_lib.utils import load_dict_from_file


if __name__ == "__main__":
    # Load data from JSON files
    cluster_data = load_dict_from_file('./data/cluster_resources.json')
    proxy_data = load_dict_from_file('./data/proxy_resources.json')
    gatekeeper_data = load_dict_from_file('./data/gatekeeper_resources.json')

    # Create Instances objects for cluster, proxy, and gatekeeper using the loaded data
    cluster_instances = Instances(
        cluster_data["instance_ids"], cluster_data["security_group"], cluster_data["key"]
    )
    proxy_instances = Instances(
        proxy_data["instance_ids"], proxy_data["security_group"], proxy_data["key"]
    )
    gatekeeper_instances = Instances(
        gatekeeper_data["instance_ids"], gatekeeper_data["security_group"], gatekeeper_data["key"]
    )

    # Terminate the gatekeeper instances and wait for them to be terminated
    gatekeeper_instances.terminate_instances()
    gatekeeper_instances.wait_for_instances_terminated()
    # Remove the security group associated with the gatekeeper instances
    gatekeeper_instances.remove_security_group()

    # Terminate the proxy instances
    proxy_instances.terminate_instances()
    proxy_instances.wait_for_instances_terminated()

    cluster_instances.teardown()
