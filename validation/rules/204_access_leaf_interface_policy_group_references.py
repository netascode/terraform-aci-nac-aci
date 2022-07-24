class Rule:
    id = "204"
    description = "Verify Access Leaf Interface Policy Group references"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            keys = [
                str(obj.get("name"))
                for obj in inventory["apic"]["access_policies"][
                    "leaf_interface_policy_groups"
                ]
            ]
            nodes = inventory["apic"]["interface_policies"]["nodes"]
            np_nodes = inventory["apic"]["node_policies"]["nodes"]
            for node in nodes:
                for np_node in np_nodes:
                    if node["id"] == np_node["id"] and np_node.get("role") == "leaf":
                        for interface in node["interfaces"]:
                            policy = interface.get("policy_group")
                            if policy and policy not in keys:
                                results.append(
                                    "apic.interface_policies.nodes.interfaces.policy_group"
                                    + " - "
                                    + str(interface.get("policy_group"))
                                )
        except KeyError:
            pass
        return results
