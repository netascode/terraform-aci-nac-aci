class Rule:
    id = "101"
    description = "Verify unique keys"
    severity = "HIGH"

    paths = [
        "apic.access_policies.qos.qos_classes.level",
        "apic.access_policies.vlan_pools.name",
        "apic.access_policies.physical_domains.name",
        "apic.access_policies.routed_domains.name",
        "apic.access_policies.aaeps.name",
        "apic.access_policies.interface_policies.cdp_policies.name",
        "apic.access_policies.interface_policies.lldp_policies.name",
        "apic.access_policies.interface_policies.link_level_policies.name",
        "apic.access_policies.interface_policies.port_channel_policies.name",
        "apic.access_policies.interface_policies.port_channel_member_policies.name",
        "apic.access_policies.interface_policies.spanning_tree_policies.name",
        "apic.access_policies.interface_policies.mcp_policies.name",
        "apic.access_policies.interface_policies.l2_policies.name",
        "apic.access_policies.interface_policies.storm_control_policies.name",
        "apic.access_policies.spine_interface_policy_groups.name",
        "apic.access_policies.switch_policies.mst_policies.name",
        "apic.access_policies.switch_policies.mst_policies.instances.name",
        "apic.access_policies.switch_policies.forwarding_scale_policies.name",
        "apic.access_policies.leaf_switch_policy_groups.name",
        "apic.access_policies.leaf_interface_policy_groups.name",
        "apic.fabric_policies.dns_policies.name",
        "apic.fabric_policies.dns_policies.providers.ip",
        "apic.fabric_policies.dns_policies.domains.name",
        "apic.fabric_policies.aaa.tacacs_providers.hostname_ip",
        "apic.fabric_policies.aaa.users.username",
        "apic.fabric_policies.aaa.users.domains.name",
        "apic.fabric_policies.aaa.users.domains.roles.name",
        "apic.fabric_policies.aaa.ca_certificates.name",
        "apic.fabric_policies.aaa.key_rings.name",
        "apic.fabric_policies.aaa.login_domains.name",
        "apic.fabric_policies.aaa.login_domains.tacacs_providers.hostname_ip",
        "apic.fabric_policies.remote_locations.name",
        "apic.fabric_policies.schedulers.name",
        "apic.fabric_policies.schedulers.recurring_windows.name",
        "apic.fabric_policies.config_exports.name",
        "apic.fabric_policies.monitoring.snmp_traps.name",
        "apic.fabric_policies.monitoring.snmp_traps.destinations.hostname_ip",
        "apic.fabric_policies.monitoring.syslogs.name",
        "apic.fabric_policies.monitoring.syslogs.destinations.hostname_ip",
        "apic.fabric_policies.fabric_bgp_rr",
        "apic.fabric_policies.fabric_bgp_ext_rr",
        "apic.fabric_policies.pod_policies.date_time_policies.name",
        "apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.ip",
        "apic.fabric_policies.pod_policies.date_time_policies.ntp_keys.id",
        "apic.fabric_policies.pod_policies.snmp_policies.name",
        "apic.fabric_policies.pod_policies.snmp_policies.users.name",
        "apic.fabric_policies.pod_policies.snmp_policies.communities",
        "apic.fabric_policies.pod_policies.snmp_policies.clients.name",
        "apic.fabric_policies.pod_policies.snmp_policies.clients.entries.name",
        "apic.fabric_policies.pod_policy_groups.name",
        "apic.fabric_policies.switch_policies.psu_policies.name",
        "apic.fabric_policies.switch_policies.node_control_policies.name",
        "apic.fabric_policies.leaf_switch_policy_groups.name",
        "apic.fabric_policies.spine_switch_policy_groups.name",
        "apic.fabric_policies.external_connectivity_policy.name",
        "apic.fabric_policies.external_connectivity_policy.external_subnets.name",
        "apic.fabric_policies.vmware_vmm_domains.name",
        "apic.fabric_policies.vmware_vmm_domains.credential_policies.name",
        "apic.fabric_policies.vmware_vmm_domains.vcenters.name",
        "apic.fabric_policies.geolocation.sites.name",
        "apic.fabric_policies.geolocation.sites.buildings.name",
        "apic.fabric_policies.geolocation.sites.buildings.floors.name",
        "apic.fabric_policies.geolocation.sites.buildings.floors.rooms.name",
        "apic.fabric_policies.geolocation.sites.buildings.floors.rooms.rows.name",
        "apic.fabric_policies.geolocation.sites.buildings.floors.rooms.rows.racks.name",
        "apic.fabric_policies.geolocation.sites.buildings.floors.rooms.rows.racks.modes",
        "apic.pod_policies.id",
        "apic.pod_policies.tep_pool",
        "apic.pod_policies.data_plane_tep",
        "apic.node_policies.update_groups.name",
        "apic.node_policies.vpc_groups.groups.id",
        "apic.node_policies.nodes.id",
        "apic.node_policies.nodes.name",
        "apic.node_policies.nodes.serial_number",
        "apic.node_policies.nodes.oob_address",
        "apic.node_policies.nodes.inb_address",
        "apic.interface_policies.nodes.id",
        "apic.interface_policies.nodes.fexes.id",
        "apic.interface_policies.nodes.fexes.interfaces.port",
        "apic.tenants.name",
        "apic.tenants.vrfs.name",
        "apic.tenants.vrfs.dns_labels",
        "apic.tenants.vrfs.contracts.consumers",
        "apic.tenants.vrfs.contracts.providers",
        "apic.tenants.vrfs.contracts.imported_consumers",
        "apic.tenants.bridge_domains.name",
        "apic.tenants.bridge_domains.subnets.ip",
        "apic.tenants.bridge_domains.l3outs",
        "apic.tenants.bridge_domains.dhcp_labels.dhcp_relay_policy",
        "apic.tenants.l3outs.name",
        "apic.tenants.l3outs.nodes.node_id",
        "apic.tenants.l3outs.nodes.router_id",
        "apic.tenants.l3outs.nodes.static_routes.prefix",
        "apic.tenants.l3outs.nodes.interfaces.ip",
        "apic.tenants.l3outs.nodes.interfaces.ip_a",
        "apic.tenants.l3outs.nodes.interfaces.ip_b",
        "apic.tenants.l3outs.nodes.interfaces.channel",
        "apic.tenants.l3outs.nodes.interfaces.bgp_peers.ip",
        "apic.tenants.l3outs.external_endpoint_groups.name",
        "apic.tenants.l3outs.external_endpoint_groups.subnet.name",
        "apic.tenants.l3outs.external_endpoint_groups.subnet.prefix",
        "apic.tenants.l3outs.external_endpoint_groups.contracts.consumers",
        "apic.tenants.l3outs.external_endpoint_groups.contracts.providers",
        "apic.tenants.l3outs.external_endpoint_groups.contracts.imported_consumers",
        "apic.tenants.l3outs.import_route_map.contexts.name",
        "apic.tenants.l3outs.export_route_map.contexts.name",
        "apic.tenants.application_profiles.name",
        "apic.tenants.application_profiles.endpoint_groups.name",
        "apic.tenants.application_profiles.endpoint_groups.physical_domains",
        "apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.name",
        "apic.tenants.application_profiles.endpoint_groups.static_ports.channel",
        "apic.tenants.application_profiles.endpoint_groups.contracts.consumers",
        "apic.tenants.application_profiles.endpoint_groups.contracts.providers",
        "apic.tenants.application_profiles.endpoint_groups.contracts.imported_consumers",
        "apic.tenants.application_profiles.endpoint_groups.subnets.ip",
        "apic.tenants.contracts.name",
        "apic.tenants.contracts.subjects.name",
        "apic.tenants.contracts.subjects.filters.filter",
        "apic.tenants.imported_contracts.name",
        "apic.tenants.filters.name",
        "apic.tenants.filters.entries.name",
        "apic.tenants.policies.ospf_interface_policies.name",
        "apic.tenants.policies.dhcp_relay_policies.name",
        "apic.tenants.policies.dhcp_option_policies.name",
        "apic.tenants.policies.dhcp_option_policies.options.name",
        "apic.tenants.policies.match_rules.name",
        "apic.tenants.policies.match_rules.prefixes.ip",
        "apic.tenants.policies.set_rules.name",
        "apic.tenants.policies.bgp_timer_policies.name",
        "apic.tenants.policies.bfd_interface_policies.name",
        "apic.tenants.services.l4l7_devices.name",
        "apic.tenants.services.l4l7_devices.concrete_devices.name",
        "apic.tenants.services.l4l7_devices.concrete_devices.interfaces.name",
        "apic.tenants.services.l4l7_devices.logical_interfaces.name",
        "apic.tenants.services.redirect_policies.name",
        "apic.tenants.services.redirect_policies.l3_destinations.ip",
        "apic.tenants.services.service_graph_templates.name",
        "apic.tenants.inb_endpoint_groups.name",
        "apic.tenants.inb_endpoint_groups.contracts.consumers",
        "apic.tenants.inb_endpoint_groups.contracts.providers",
        "apic.tenants.inb_endpoint_groups.contracts.imported_consumers",
        "apic.tenants.oob_endpoint_groups.name",
        "apic.tenants.oob_endpoint_groups.oob_contracts.providers",
        "apic.tenants.ext_mgmt_instances.name",
        "apic.tenants.ext_mgmt_instances.subnets",
        "apic.tenants.ext_mgmt_instances.oob_contracts.consumers",
        "apic.tenants.oob_contracts.name",
        "apic.tenants.oob_contracts.subjects.name",
        "apic.tenants.oob_contracts.subjects.filters.filter",
        "ndo.remote_locations.name",
        "ndo.tacacs_providers.hostname_ip",
        "ndo.login_domains.name",
        "ndo.login_domains.providers.host",
        "ndo.ca_certificates.name",
        "ndo.users.username",
        "ndo.users.roles.role",
        "ndo.sites.name",
        "ndo.sites.apic_urls",
        "ndo.sites.ospf_policies.name",
        "ndo.sites.pods.id",
        "ndo.sites.pods.unicast_tep",
        "ndo.sites.pods.spines.id",
        "ndo.sites.pods.spines.name",
        "ndo.sites.pods.spines.control_plane_tep",
        "ndo.tenants.name",
        "ndo.tenants.sites",
        "ndo.policies.dhcp_relays.name",
        "ndo.policies.dhcp_options.name",
        "ndo.policies.dhcp_options.options.name",
        "ndo.schemas.name",
        "ndo.schemas.templates.name",
        "ndo.schemas.templates.application_profiles.name",
        "ndo.schemas.templates.application_profiles.endpoint_groups.name",
        "ndo.schemas.templates.application_profiles.endpoint_groups.subnets.ip",
        "ndo.schemas.templates.application_profiles.endpoint_groups.contracts.consumers",
        "ndo.schemas.templates.application_profiles.endpoint_groups.contracts.providers",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.name",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.physical_domains.name",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.name",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.channel",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_leafs.node",
        "ndo.schemas.templates.application_profiles.endpoint_groups.sites.subnets.ip",
        "ndo.schemas.templates.vrfs.name",
        "ndo.schemas.templates.bridge_domains.name",
        "ndo.schemas.templates.bridge_domains.subnets.ip",
        "ndo.schemas.templates.bridge_domains.sites.name",
        "ndo.schemas.templates.bridge_domains.sites.l3outs",
        "ndo.schemas.templates.filters.name",
        "ndo.schemas.templates.filters.entries.name",
        "ndo.schemas.templates.l3outs.name",
        "ndo.schemas.templates.external_endpoint_groups.name",
        "ndo.schemas.templates.external_endpoint_groups.subnets.prefix",
        "ndo.schemas.templates.external_endpoint_groups.contracts.consumers",
        "ndo.schemas.templates.external_endpoint_groups.contracts.providers",
        "ndo.schemas.templates.external_endpoint_groups.sites.name",
        "ndo.schemas.templates.contracts.name",
        "ndo.schemas.templates.contracts.service_graph.nodes.name",
        "ndo.schemas.templates.contracts.service_graph.nodes.provider.sites.name",
        "ndo.schemas.templates.contracts.service_graph.nodes.consumer.sites.name",
        "ndo.schemas.templates.service_graphs.name",
        "ndo.schemas.templates.service_graphs.nodes.name",
        "ndo.schemas.templates.service_graphs.nodes.sites.name",
        "ndo.schemas.templates.sites.name",
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements[:-1]):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(i, full_path, ".".join(path_elements[idx:]))
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        values = []
        if isinstance(inv_element, list):
            for i in inv_element:
                if not isinstance(i, dict):
                    continue
                value = i.get(path_elements[-1])
                if isinstance(value, list):
                    values = []
                    for v in value:
                        if v not in values:
                            values.append(v)
                        else:
                            results.append(full_path + " - " + str(v))
                elif value:
                    if value not in values:
                        values.append(value)
                    else:
                        results.append(full_path + " - " + str(value))
        elif isinstance(inv_element, dict):
            list_element = inv_element.get(path_elements[-1])
            if isinstance(list_element, list):
                for value in list_element:
                    if value:
                        if value not in values:
                            values.append(value)
                        else:
                            results.append(full_path + " - " + str(value))
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            r = cls.match_path(inventory, path, path)
            results.extend(r)
        return results
