from python_lib.instances import Instances
from python_lib.utils import load_dict_from_file

if __name__ == "__main__":
    data = load_dict_from_file('./data/cluster_resources.json')
    instances = Instances(
        data["instance_ids"], data["security_group"], data["key"]
    )

    print(' '.join(instances.getPrivateDnsName(instances.instance_ids)))
