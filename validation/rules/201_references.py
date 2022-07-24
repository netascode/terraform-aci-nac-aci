class Rule:
    id = "201"
    description = "Verify references"
    severity = "HIGH"

    paths = [
        {
            "key": "apic.node_policies.nodes.id",
            "references": [
                "apic.fabric_policies.fabric_bgp_rr",
                "apic.fabric_policies.fabric_bgp_ext_rr",
                "apic.node_policies.vpc_groups.groups.switch_1",
                "apic.node_policies.vpc_groups.groups.switch_2",
                "apic.interface_policies.nodes.id",
                "apic.tenants.l3outs.nodes.node_id",
                "apic.tenants.application_profiles.endpoint_groups.static_ports.node_id",
                "apic.tenants.services.l4l7_devices.concrete_devices.interfaces.node_id",
            ],
        },
        {
            "key": "apic.node_policies.update_groups.name",
            "references": [
                "apic.node_policies.nodes.update_group",
            ],
        },
        {
            "key": "apic.fabric_policies.aaa.ca_certificates.name",
            "references": [
                "apic.fabric_policies.aaa.key_rings.ca_certificate",
            ],
        },
        {
            "key": "apic.fabric_policies.aaa.tacacs_providers.hostname_ip",
            "references": [
                "apic.fabric_policies.aaa.login_domains.tacacs_providers.hostname_ip",
            ],
        },
        {
            "key": "apic.fabric_policies.remote_locations.name",
            "references": [
                "apic.fabric_policies.config_exports.remote_location",
            ],
        },
        {
            "key": "apic.fabric_policies.schedulers.name",
            "references": [
                "apic.fabric_policies.config_exports.scheduler",
            ],
        },
        {
            "key": "apic.fabric_policies.pod_policies.snmp_policies.name",
            "references": [
                "apic.fabric_policies.pod_policy_groups.snmp_policy",
            ],
        },
        {
            "key": "apic.fabric_policies.pod_policies.date_time_policies.name",
            "references": [
                "apic.fabric_policies.pod_policy_groups.date_time_policy",
            ],
        },
        {
            "key": "apic.fabric_policies.pod_policy_groups.name",
            "references": [
                "apic.pod_policies.pods.policy",
            ],
        },
        {
            "key": "apic.fabric_policies.switch_policies.psu_policies.name",
            "references": [
                "apic.fabric_policies.leaf_switch_policy_groups.psu_policy",
                "apic.fabric_policies.spine_switch_policy_groups.psu_policy",
            ],
        },
        {
            "key": "apic.fabric_policies.switch_policies.node_control_policies.name",
            "references": [
                "apic.fabric_policies.leaf_switch_policy_groups.node_control_policy",
                "apic.fabric_policies.spine_switch_policy_groups.node_control_policy",
            ],
        },
        {
            "key": "apic.access_policies.vlan_pools.name",
            "references": [
                "apic.access_policies.physical_domains.vlan_pool",
                "apic.access_policies.routed_domains.vlan_pool",
                "apic.fabric_policies.vmware_vmm_domains.vlan_pool",
            ],
        },
        {
            "key": "apic.access_policies.physical_domains.name",
            "references": [
                "apic.access_policies.aaeps.physical_domains",
            ],
        },
        {
            "key": "apic.access_policies.routed_domains.name",
            "references": [
                "apic.access_policies.aaeps.routed_domains",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.link_level_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.link_level_policy",
                "apic.access_policies.spine_interface_policy_groups.link_level_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.cdp_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.cdp_policy",
                "apic.access_policies.spine_interface_policy_groups.cdp_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.lldp_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.lldp_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.spanning_tree_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.spanning_tree_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.mcp_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.mcp_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.l2_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.l2_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.port_channel_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.port_channel_policy",
            ],
        },
        {
            "key": "apic.access_policies.interface_policies.port_channel_member_policies.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.port_channel_member_policy",
            ],
        },
        {
            "key": "apic.access_policies.aaeps.name",
            "references": [
                "apic.access_policies.leaf_interface_policy_groups.aaep",
                "apic.access_policies.spine_interface_policy_groups.aaep",
            ],
        },
        {
            "key": "apic.access_policies.switch_policies.forwarding_scale_policies.name",
            "references": [
                "apic.access_policies.leaf_switch_policy_groups.forwarding_scale_policy",
            ],
        },
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path, targets):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(
                        i, full_path, ".".join(path_elements[idx:]), targets
                    )
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        if isinstance(inv_element, list):
            for e in inv_element:
                if str(e) not in targets:
                    results.append(full_path + " - " + str(e))
        elif str(inv_element) not in targets:
            results.append(full_path + " - " + str(inv_element))
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            key_elements = path["key"].split(".")
            try:
                element = inventory
                for k in key_elements[:-1]:
                    element = element[k]
                keys = [str(obj.get(key_elements[-1])) for obj in element]
            except KeyError:
                continue
            for ref in path["references"]:
                r = cls.match_path(inventory, ref, ref, keys)
                results.extend(r)
        return results
