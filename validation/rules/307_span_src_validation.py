class Rule:
    id = "307"
    description = "Verify SPAN Configurations"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            source_groups = inventory.get("apic",{}).get("access_policies",{}).get("span",{}).get("source_groups",[])
            for src_grp in source_groups:
                for src in src_grp.get("sources",[]):
                    for path in src.get("access_paths",[]):
                        if path["type"] == "vpc":
                            if "channel" not in path:
                                results.append(f"apic.access_policies.span.source_groups - Source group {src['name']} is using vPC where channel is not defined.")
                        elif path["type"] == "component":
                            if "node2_id" in path:
                                results.append(f"apic.access_policies.span.source_groups - Source group {src['name']} is using vPC component where Node2 ID should not be defined.")

        except KeyError:
            pass
        return results
