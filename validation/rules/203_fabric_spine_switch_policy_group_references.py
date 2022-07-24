class Rule:
    id = "203"
    description = "Verify Fabric Spine Switch Policy Group references"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            keys = [
                str(obj.get("name"))
                for obj in inventory["apic"]["fabric_policies"][
                    "spine_switch_policy_groups"
                ]
            ]
            nodes = inventory["apic"]["node_policies"]["nodes"]
            for node in nodes:
                if node.get("role") == "spine":
                    policy = node.get("fabric_policy_group")
                    if policy and policy not in keys:
                        results.append(
                            "apic.node_policies.nodes.fabric_policy_group"
                            + " - "
                            + str(node.get("fabric_policy_group"))
                        )
        except KeyError:
            pass
        return results
