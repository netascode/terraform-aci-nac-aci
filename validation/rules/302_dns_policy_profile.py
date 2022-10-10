class Rule:
    id = "302"
    description = "Verify the DNS Policy Profiles"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            dns_policy = inventory["apic"]["fabric_policies"]["dns_policies"]

            for x in dns_policy:
                if len(x.setdefault("providers", [])) > 2:
                    results.append(
                        "apic.fabric_policies.dns_policies.providers - "
                        + x.get("name")
                        + " has more than 2 DNS providers"
                    )
        except KeyError:
            pass
        return results
