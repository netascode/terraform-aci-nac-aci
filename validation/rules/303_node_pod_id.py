class Rule:
    id = "303"
    description = "Verify node pod IDs"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            nodes = inventory["apic"]["node_policies"]["nodes"]

            for node in nodes:
                if node.get("pod") == 0 and node.get("role") != "apic":
                    results.append(
                        f"apic.node_policies.nodes.pod_id - {node.get('role')} "
                        f"{node.get('id')} is added to the APIC pod (0)"
                    )

        except KeyError:
            pass
        return results
