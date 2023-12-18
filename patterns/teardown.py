
from instances import Instances
from utils import load_dict_from_file

"""Imports the Instances class from the instances module.
Imports the load_dict_from_file function from the utils module.
Loads a dictionary (data) from a JSON file named ./data/aws_resources.json using the load_dict_from_file function.
Creates an instance of the Instances class using the data loaded from the file.
Calls the teardown() method on the instances object, presumably to perform cleanup or termination of resources created during the setup phase.
"""

if __name__ == "__main__":
    cluster_data = load_dict_from_file('./data/cluster_resources.json')
    proxy_data = load_dict_from_file('./data/proxy_resources.json')
    gatekeeper_data = load_dict_from_file('./data/gatekeeper_resources.json')

    cluster_instances = Instances(
        cluster_data["instance_ids"], cluster_data["security_group"], cluster_data["key"]
    )
    proxy_instances = Instances(
        proxy_data["instance_ids"], proxy_data["security_group"], proxy_data["key"]
    )
    gatekeeper_instances = Instances(
        gatekeeper_data["instance_ids"], gatekeeper_data["security_group"], gatekeeper_data["key"]
    )

    cluster_instances.teardown()
    proxy_instances.teardown()
    gatekeeper_instances.teardown()
