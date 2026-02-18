module "aci_tenant" {
  source = "./modules/terraform-aci-tenant"

  for_each         = { for tenant in local.tenants : tenant.name => tenant if try(tenant.managed, local.defaults.apic.tenants.managed, true) && local.modules.aci_tenant && var.manage_tenants }
  name             = each.value.name
  annotation       = try(each.value.ndo_managed, local.defaults.apic.tenants.ndo_managed) ? "orchestrator:msc" : null
  alias            = try(each.value.alias, "")
  description      = try(each.value.description, "")
  security_domains = try(each.value.security_domains, [])
}

locals {
  vrfs = flatten([
    for tenant in local.tenants : [
      for vrf in try(tenant.vrfs, []) : {
        key                                     = format("%s/%s", tenant.name, vrf.name)
        tenant                                  = tenant.name
        name                                    = "${vrf.name}${local.defaults.apic.tenants.vrfs.name_suffix}"
        annotation                              = try(vrf.ndo_managed, local.defaults.apic.tenants.vrfs.ndo_managed) ? "orchestrator:msc-shadow:no" : null
        alias                                   = try(vrf.alias, "")
        description                             = try(vrf.description, "")
        enforcement_direction                   = try(vrf.ndo_managed, local.defaults.apic.tenants.vrfs.ndo_managed) ? null : try(vrf.enforcement_direction, local.defaults.apic.tenants.vrfs.enforcement_direction)
        enforcement_preference                  = try(vrf.enforcement_preference, local.defaults.apic.tenants.vrfs.enforcement_preference)
        data_plane_learning                     = try(vrf.data_plane_learning, local.defaults.apic.tenants.vrfs.data_plane_learning)
        contract_consumers                      = try([for contract in vrf.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
        contract_providers                      = try([for contract in vrf.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
        contract_imported_consumers             = try([for contract in vrf.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
        preferred_group                         = try(vrf.preferred_group, local.defaults.apic.tenants.vrfs.preferred_group)
        transit_route_tag_policy                = try(vrf.transit_route_tag_policy, null) != null ? "${vrf.transit_route_tag_policy}${local.defaults.apic.tenants.policies.route_tag_policies.name_suffix}" : ""
        endpoint_retention_policy               = try("${vrf.endpoint_retention_policy}${local.defaults.apic.tenants.policies.endpoint_retention_policies.name_suffix}", "")
        ospf_timer_policy                       = try("${vrf.ospf.timer_policy}${local.defaults.apic.tenants.policies.ospf_timer_policies.name_suffix}", "")
        ospf_ipv4_address_family_context_policy = try("${vrf.ospf.ipv4_address_family_context_policy}${local.defaults.apic.tenants.policies.ospf_timer_policies.name_suffix}", "")
        ospf_ipv6_address_family_context_policy = try("${vrf.ospf.ipv6_address_family_context_policy}${local.defaults.apic.tenants.policies.ospf_timer_policies.name_suffix}", "")
        bgp_timer_policy                        = try("${vrf.bgp.timer_policy}${local.defaults.apic.tenants.policies.bgp_timer_policies.name_suffix}", "")
        bgp_ipv4_address_family_context_policy  = try("${vrf.bgp.ipv4_address_family_context_policy}${local.defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix}", "")
        bgp_ipv6_address_family_context_policy  = try("${vrf.bgp.ipv6_address_family_context_policy}${local.defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix}", "")
        bgp_ipv4_import_route_target            = try(vrf.bgp.ipv4_import_route_target, [])
        bgp_ipv4_export_route_target            = try(vrf.bgp.ipv4_export_route_target, [])
        bgp_ipv6_import_route_target            = try(vrf.bgp.ipv6_import_route_target, [])
        bgp_ipv6_export_route_target            = try(vrf.bgp.ipv6_export_route_target, [])
        dns_labels                              = try(vrf.dns_labels, [])
        snmp_context_name                       = try(vrf.snmp_context.name, null) != null ? "${vrf.snmp_context.name}${local.defaults.apic.tenants.vrfs.snmp_context.name_suffix}" : null
        snmp_context_community_profiles = [for comm_profile in try(vrf.snmp_context.community_profiles, []) : {
          name        = "${comm_profile.name}${local.defaults.apic.tenants.vrfs.snmp_context.community_profiles.name_suffix}"
          description = try(comm_profile.description, null) != null ? comm_profile.description : ""
        }]
        pim_enabled                             = try(vrf.pim, null) != null ? true : false
        pim_mtu                                 = try(vrf.pim.mtu, local.defaults.apic.tenants.vrfs.pim.mtu)
        pim_fast_convergence                    = try(vrf.pim.fast_convergence, local.defaults.apic.tenants.vrfs.pim.fast_convergence)
        pim_strict_rfc                          = try(vrf.pim.strict_rfc, local.defaults.apic.tenants.vrfs.pim.strict_rfc)
        pim_max_multicast_entries               = try(vrf.pim.max_multicast_entries, local.defaults.apic.tenants.vrfs.pim.max_multicast_entries)
        pim_reserved_multicast_entries          = try(vrf.pim.reserved_multicast_entries, local.defaults.apic.tenants.vrfs.pim.reserved_multicast_entries)
        pim_resource_policy_multicast_route_map = try(vrf.pim.resource_policy_multicast_route_map, null) != null ? "${vrf.pim.resource_policy_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_static_rps = [for rp in try(vrf.pim.static_rps, []) : {
          ip                  = rp.ip
          multicast_route_map = try(rp.multicast_route_map, null) != null ? "${rp.multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        }]
        pim_fabric_rps = [for rp in try(vrf.pim.fabric_rps, []) : {
          ip                  = rp.ip
          multicast_route_map = try(rp.multicast_route_map, null) != null ? "${rp.multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        }]
        pim_bsr_listen_updates                   = try(vrf.pim.bsr_listen_updates, local.defaults.apic.tenants.vrfs.pim.bsr_listen_updates)
        pim_bsr_forward_updates                  = try(vrf.pim.bsr_forward_updates, local.defaults.apic.tenants.vrfs.pim.bsr_forward_updates)
        pim_bsr_filter_multicast_route_map       = try(vrf.pim.bsr_filter_multicast_route_map, null) != null ? "${vrf.pim.bsr_filter_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_auto_rp_listen_updates               = try(vrf.pim.auto_rp_listen_updates, local.defaults.apic.tenants.vrfs.pim.auto_rp_listen_updates)
        pim_auto_rp_forward_updates              = try(vrf.pim.auto_rp_forward_updates, local.defaults.apic.tenants.vrfs.pim.auto_rp_forward_updates)
        pim_auto_rp_filter_multicast_route_map   = try(vrf.pim.auto_rp_filter_multicast_route_map, null) != null ? "${vrf.pim.auto_rp_filter_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_asm_shared_range_multicast_route_map = try(vrf.pim.asm_shared_range_multicast_route_map, null) != null ? "${vrf.pim.asm_shared_range_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_asm_sg_expiry                        = try(vrf.pim.asm_sg_expiry, local.defaults.apic.tenants.vrfs.pim.asm_sg_expiry)
        pim_asm_sg_expiry_multicast_route_map    = try(vrf.pim.asm_sg_expiry_multicast_route_map, null) != null ? "${vrf.pim.asm_sg_expiry_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_asm_traffic_registry_max_rate        = try(vrf.pim.asm_traffic_registry_max_rate, local.defaults.apic.tenants.vrfs.pim.asm_traffic_registry_max_rate)
        pim_asm_traffic_registry_source_ip       = try(vrf.pim.asm_traffic_registry_source_ip, local.defaults.apic.tenants.vrfs.pim.asm_traffic_registry_source_ip)
        pim_ssm_group_range_multicast_route_map  = try(vrf.pim.ssm_group_range_multicast_route_map, null) != null ? "${vrf.pim.ssm_group_range_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        pim_inter_vrf_policies = [for pol in try(vrf.pim.inter_vrf_policies, []) : {
          tenant              = pol.tenant
          vrf                 = "${pol.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}"
          multicast_route_map = try(pol.multicast_route_map, null) != null ? "${pol.multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        }]
        pim_igmp_ssm_translate_policies = [for pol in try(vrf.pim.igmp_context_ssm_translate_policies, []) : {
          group_prefix   = pol.group_prefix
          source_address = pol.source_address
        }]
        leaked_internal_subnets = [for prefix in try(vrf.leaked_internal_subnets, []) : {
          prefix = prefix.prefix
          public = try(prefix.public, local.defaults.apic.tenants.vrfs.leaked_internal_subnets.public)
          destinations = [for dest in try(prefix.destinations, []) : {
            description = try(dest.description, "")
            tenant      = dest.tenant
            vrf         = dest.vrf
            public      = try(dest.public, null)
          }]
        }]
        leaked_internal_prefixes = [for prefix in try(vrf.leaked_internal_prefixes, []) : {
          prefix             = prefix.prefix
          public             = try(prefix.public, local.defaults.apic.tenants.vrfs.leaked_internal_prefixes.public)
          from_prefix_length = try(prefix.from_prefix_length, null)
          to_prefix_length   = try(prefix.to_prefix_length, null)
          destinations = [for dest in try(prefix.destinations, []) : {
            description = try(dest.description, "")
            tenant      = dest.tenant
            vrf         = dest.vrf
            public      = try(dest.public, null)
          }]
        }]
        leaked_external_prefixes = [for prefix in try(vrf.leaked_external_prefixes, []) : {
          prefix             = prefix.prefix
          from_prefix_length = try(prefix.from_prefix_length, null)
          to_prefix_length   = try(prefix.to_prefix_length, null)
          destinations = [for dest in try(prefix.destinations, []) : {
            description = try(dest.description, "")
            tenant      = dest.tenant
            vrf         = dest.vrf
          }]
        }]
        route_summarization_policies = [for pol in try(vrf.route_summarization_policies, []) : {
          name = "${pol.name}${local.defaults.apic.tenants.vrfs.route_summarization_policies.name_suffix}"
          nodes = [for node in try(pol.nodes, []) : {
            id  = node.id
            pod = try(node.pod, local.defaults.apic.tenants.vrfs.route_summarization_policies.nodes.pod)
          }]
          subnets = [for subnet in try(pol.subnets, []) : {
            prefix                         = subnet.prefix
            bgp_route_summarization_policy = try(subnet.bgp_route_summarization_policy, null) != null ? "${subnet.bgp_route_summarization_policy}${local.defaults.apic.tenants.policies.bgp_route_summarization_policies.name_suffix}" : null
          }]
        }]
      }
    ]
  ])
}

module "aci_vrf" {
  source = "./modules/terraform-aci-vrf"

  for_each                                 = { for vrf in local.vrfs : vrf.key => vrf if local.modules.aci_vrf && var.manage_tenants }
  tenant                                   = each.value.tenant
  name                                     = each.value.name
  annotation                               = each.value.annotation
  alias                                    = each.value.alias
  description                              = each.value.description
  snmp_context_name                        = each.value.snmp_context_name
  snmp_context_community_profiles          = each.value.snmp_context_community_profiles
  enforcement_direction                    = each.value.enforcement_direction
  enforcement_preference                   = each.value.enforcement_preference
  data_plane_learning                      = each.value.data_plane_learning
  contract_consumers                       = each.value.contract_consumers
  contract_providers                       = each.value.contract_providers
  contract_imported_consumers              = each.value.contract_imported_consumers
  preferred_group                          = each.value.preferred_group
  transit_route_tag_policy                 = each.value.transit_route_tag_policy
  endpoint_retention_policy                = each.value.endpoint_retention_policy
  ospf_timer_policy                        = each.value.ospf_timer_policy
  ospf_ipv4_address_family_context_policy  = each.value.ospf_ipv4_address_family_context_policy
  ospf_ipv6_address_family_context_policy  = each.value.ospf_ipv6_address_family_context_policy
  bgp_timer_policy                         = each.value.bgp_timer_policy
  bgp_ipv4_address_family_context_policy   = each.value.bgp_ipv4_address_family_context_policy
  bgp_ipv6_address_family_context_policy   = each.value.bgp_ipv6_address_family_context_policy
  bgp_ipv4_import_route_target             = each.value.bgp_ipv4_import_route_target
  bgp_ipv4_export_route_target             = each.value.bgp_ipv4_export_route_target
  bgp_ipv6_import_route_target             = each.value.bgp_ipv6_import_route_target
  bgp_ipv6_export_route_target             = each.value.bgp_ipv6_export_route_target
  dns_labels                               = each.value.dns_labels
  pim_enabled                              = each.value.pim_enabled
  pim_mtu                                  = each.value.pim_mtu
  pim_fast_convergence                     = each.value.pim_fast_convergence
  pim_strict_rfc                           = each.value.pim_strict_rfc
  pim_max_multicast_entries                = each.value.pim_max_multicast_entries
  pim_reserved_multicast_entries           = each.value.pim_reserved_multicast_entries
  pim_resource_policy_multicast_route_map  = each.value.pim_resource_policy_multicast_route_map
  pim_static_rps                           = each.value.pim_static_rps
  pim_fabric_rps                           = each.value.pim_fabric_rps
  pim_bsr_listen_updates                   = each.value.pim_bsr_listen_updates
  pim_bsr_forward_updates                  = each.value.pim_bsr_forward_updates
  pim_bsr_filter_multicast_route_map       = each.value.pim_bsr_filter_multicast_route_map
  pim_auto_rp_listen_updates               = each.value.pim_auto_rp_listen_updates
  pim_auto_rp_forward_updates              = each.value.pim_auto_rp_forward_updates
  pim_auto_rp_filter_multicast_route_map   = each.value.pim_auto_rp_filter_multicast_route_map
  pim_asm_shared_range_multicast_route_map = each.value.pim_asm_shared_range_multicast_route_map
  pim_asm_sg_expiry                        = each.value.pim_asm_sg_expiry
  pim_asm_sg_expiry_multicast_route_map    = each.value.pim_asm_sg_expiry_multicast_route_map
  pim_asm_traffic_registry_max_rate        = each.value.pim_asm_traffic_registry_max_rate
  pim_asm_traffic_registry_source_ip       = each.value.pim_asm_traffic_registry_source_ip
  pim_ssm_group_range_multicast_route_map  = each.value.pim_ssm_group_range_multicast_route_map
  pim_inter_vrf_policies                   = each.value.pim_inter_vrf_policies
  pim_igmp_ssm_translate_policies          = each.value.pim_igmp_ssm_translate_policies
  leaked_internal_subnets                  = each.value.leaked_internal_subnets
  leaked_internal_prefixes                 = each.value.leaked_internal_prefixes
  leaked_external_prefixes                 = each.value.leaked_external_prefixes
  route_summarization_policies             = each.value.route_summarization_policies

  depends_on = [
    module.aci_tenant,
    module.aci_contract,
    module.aci_imported_contract,
    module.aci_bgp_timer_policy,
    module.aci_bgp_route_summarization_policy,
    module.aci_endpoint_retention_policy,
  ]
}

locals {
  bridge_domains = flatten([
    for tenant in local.tenants : [
      for bd in try(tenant.bridge_domains, []) : {
        key                        = format("%s/%s", tenant.name, bd.name)
        tenant                     = tenant.name
        name                       = "${bd.name}${local.defaults.apic.tenants.bridge_domains.name_suffix}"
        annotation                 = try(bd.ndo_managed, local.defaults.apic.tenants.bridge_domains.ndo_managed) ? "orchestrator:msc-shadow:no" : null
        alias                      = try(bd.alias, "")
        description                = try(bd.description, "")
        arp_flooding               = try(bd.arp_flooding, local.defaults.apic.tenants.bridge_domains.arp_flooding)
        advertise_host_routes      = try(bd.advertise_host_routes, local.defaults.apic.tenants.bridge_domains.advertise_host_routes)
        ip_dataplane_learning      = try(bd.ip_dataplane_learning, local.defaults.apic.tenants.bridge_domains.ip_dataplane_learning)
        limit_ip_learn_to_subnets  = try(bd.limit_ip_learn_to_subnets, local.defaults.apic.tenants.bridge_domains.limit_ip_learn_to_subnets)
        mac                        = try(bd.mac, local.defaults.apic.tenants.bridge_domains.mac)
        virtual_mac                = try(bd.virtual_mac, "not-applicable")
        ep_move_detection          = try(bd.ep_move_detection, local.defaults.apic.tenants.bridge_domains.ep_move_detection)
        clear_remote_mac_entries   = try(bd.clear_remote_mac_entries, local.defaults.apic.tenants.bridge_domains.clear_remote_mac_entries)
        multicast_arp_drop         = try(bd.multicast_arp_drop, null)
        l3_multicast               = try(bd.l3_multicast, local.defaults.apic.tenants.bridge_domains.l3_multicast)
        pim_source_filter          = try(bd.pim_source_filter, "")
        pim_destination_filter     = try(bd.pim_destination_filter, "")
        multi_destination_flooding = try(bd.multi_destination_flooding, local.defaults.apic.tenants.bridge_domains.multi_destination_flooding)
        unicast_routing            = try(bd.unicast_routing, local.defaults.apic.tenants.bridge_domains.unicast_routing)
        unknown_unicast            = try(bd.unknown_unicast, local.defaults.apic.tenants.bridge_domains.unknown_unicast)
        unknown_ipv4_multicast     = try(bd.unknown_ipv4_multicast, local.defaults.apic.tenants.bridge_domains.unknown_ipv4_multicast)
        unknown_ipv6_multicast     = try(bd.unknown_ipv6_multicast, local.defaults.apic.tenants.bridge_domains.unknown_ipv6_multicast)
        vrf                        = "${bd.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}"
        igmp_interface_policy      = try("${bd.igmp_interface_policy}${local.defaults.apic.tenants.policies.igmp_interface_policies.name_suffix}", "")
        igmp_snooping_policy       = try("${bd.igmp_snooping_policy}${local.defaults.apic.tenants.policies.igmp_snooping_policies.name_suffix}", "")
        nd_interface_policy        = try("${bd.nd_interface_policy}${local.defaults.apic.tenants.policies.nd_interface_policies.name_suffix}", "")
        endpoint_retention_policy  = try("${bd.endpoint_retention_policy}${local.defaults.apic.tenants.policies.endpoint_retention_policies.name_suffix}", "")
        legacy_mode_vlan           = try(bd.legacy_mode_vlan, null)
        subnets = [for subnet in try(bd.subnets, []) : {
          ip                    = subnet.ip
          description           = try(subnet.description, "")
          primary_ip            = try(subnet.primary_ip, local.defaults.apic.tenants.bridge_domains.subnets.primary_ip)
          public                = try(subnet.public, local.defaults.apic.tenants.bridge_domains.subnets.public)
          shared                = try(subnet.shared, local.defaults.apic.tenants.bridge_domains.subnets.shared)
          igmp_querier          = try(subnet.igmp_querier, local.defaults.apic.tenants.bridge_domains.subnets.igmp_querier)
          nd_ra_prefix          = try(subnet.nd_ra_prefix, local.defaults.apic.tenants.bridge_domains.subnets.nd_ra_prefix)
          no_default_gateway    = try(subnet.no_default_gateway, local.defaults.apic.tenants.bridge_domains.subnets.no_default_gateway)
          virtual               = try(subnet.virtual, local.defaults.apic.tenants.bridge_domains.subnets.virtual)
          nd_ra_prefix_policy   = try("${subnet.nd_ra_prefix_policy}${local.defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix}", "")
          ip_dataplane_learning = try(subnet.ip_dataplane_learning, null)
        }]
        l3outs = try(bd.l3outs, null) != null ? [for l3out in bd.l3outs : "${l3out}${local.defaults.apic.tenants.l3outs.name_suffix}"] : []
        dhcp_labels = [for label in try(bd.dhcp_labels, []) : {
          dhcp_relay_policy  = try("${label.dhcp_relay_policy}${local.defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix}", "")
          dhcp_option_policy = try("${label.dhcp_option_policy}${local.defaults.apic.tenants.policies.dhcp_option_policies.name_suffix}", "")
          scope              = try(label.scope, local.defaults.apic.tenants.bridge_domains.dhcp_labels.scope)
        }]
        netflow_monitor_policies = [for policy in try(bd.netflow_monitor_policies, []) : {
          name           = try("${policy.name}${local.defaults.apic.tenants.policies.netflow_monitors.name_suffix}", "")
          ip_filter_type = try(policy.ip_filter_type, local.defaults.apic.tenants.bridge_domains.netflow_monitor_policies.ip_filter_type)
        }]
      }
    ]
  ])
}

module "aci_bridge_domain" {
  source = "./modules/terraform-aci-bridge-domain"

  for_each                   = { for bd in local.bridge_domains : bd.key => bd if local.modules.aci_bridge_domain && var.manage_tenants }
  tenant                     = each.value.tenant
  name                       = each.value.name
  annotation                 = each.value.annotation
  alias                      = each.value.alias
  description                = each.value.description
  arp_flooding               = each.value.arp_flooding
  advertise_host_routes      = each.value.advertise_host_routes
  ip_dataplane_learning      = each.value.ip_dataplane_learning
  limit_ip_learn_to_subnets  = each.value.limit_ip_learn_to_subnets
  mac                        = each.value.mac
  virtual_mac                = each.value.virtual_mac
  ep_move_detection          = each.value.ep_move_detection
  clear_remote_mac_entries   = each.value.clear_remote_mac_entries
  multicast_arp_drop         = each.value.multicast_arp_drop
  l3_multicast               = each.value.l3_multicast
  pim_source_filter          = each.value.pim_source_filter
  pim_destination_filter     = each.value.pim_destination_filter
  multi_destination_flooding = each.value.multi_destination_flooding
  unicast_routing            = each.value.unicast_routing
  unknown_unicast            = each.value.unknown_unicast
  unknown_ipv4_multicast     = each.value.unknown_ipv4_multicast
  unknown_ipv6_multicast     = each.value.unknown_ipv6_multicast
  vrf                        = each.value.vrf
  igmp_interface_policy      = each.value.igmp_interface_policy
  igmp_snooping_policy       = each.value.igmp_snooping_policy
  nd_interface_policy        = each.value.nd_interface_policy
  endpoint_retention_policy  = each.value.endpoint_retention_policy
  legacy_mode_vlan           = each.value.legacy_mode_vlan
  subnets                    = each.value.subnets
  l3outs                     = each.value.l3outs
  dhcp_labels                = each.value.dhcp_labels
  netflow_monitor_policies   = each.value.netflow_monitor_policies

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
    module.aci_l3out,
    module.aci_dhcp_relay_policy,
    module.aci_dhcp_option_policy,
    module.aci_endpoint_retention_policy,
  ]
}

locals {
  application_profiles = flatten([
    for tenant in local.tenants : [
      for ap in try(tenant.application_profiles, []) : {
        key         = format("%s/%s", tenant.name, ap.name)
        tenant      = tenant.name
        name        = "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}"
        annotation  = try(ap.ndo_managed, local.defaults.apic.tenants.application_profiles.ndo_managed) ? "orchestrator:msc-shadow:no" : null
        alias       = try(ap.alias, "")
        description = try(ap.description, "")
      } if try(ap.managed, local.defaults.apic.tenants.application_profiles.managed, true)
    ]
  ])
}

module "aci_application_profile" {
  source = "./modules/terraform-aci-application-profile"

  for_each    = { for ap in local.application_profiles : ap.key => ap if local.modules.aci_application_profile && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  annotation  = each.value.annotation
  alias       = each.value.alias
  description = each.value.description

  depends_on = [
    module.aci_tenant
  ]
}

locals {
  # first iteration to resolve node_id and determine IPG type for static ports
  endpoint_groups = flatten([
    for tenant in local.tenants : [
      for ap in try(tenant.application_profiles, []) : [
        for epg in try(ap.endpoint_groups, []) : {
          key                         = format("%s/%s/%s", tenant.name, ap.name, epg.name)
          tenant                      = tenant.name
          application_profile         = "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}"
          name                        = "${epg.name}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}"
          annotation                  = try(epg.ndo_managed, local.defaults.apic.tenants.application_profiles.endpoint_groups.ndo_managed) ? "orchestrator:msc-shadow:no" : null
          alias                       = try(epg.alias, "")
          description                 = try(epg.description, "")
          flood_in_encap              = try(epg.flood_in_encap, local.defaults.apic.tenants.application_profiles.endpoint_groups.flood_in_encap)
          intra_epg_isolation         = try(epg.intra_epg_isolation, local.defaults.apic.tenants.application_profiles.endpoint_groups.intra_epg_isolation)
          proxy_arp                   = try(epg.proxy_arp, local.defaults.apic.tenants.application_profiles.endpoint_groups.proxy_arp)
          preferred_group             = try(epg.preferred_group, local.defaults.apic.tenants.application_profiles.endpoint_groups.preferred_group)
          qos_class                   = try(epg.qos_class, local.defaults.apic.tenants.application_profiles.endpoint_groups.qos_class)
          custom_qos_policy           = try("${epg.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
          bridge_domain               = try("${epg.bridge_domain}${local.defaults.apic.tenants.bridge_domains.name_suffix}", "")
          data_plane_policing_policy  = try("${epg.data_plane_policing_policy}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}", "")
          tags                        = try(epg.tags, [])
          trust_control_policy        = try("${epg.trust_control_policy}${local.defaults.apic.tenants.policies.trust_control_policies.name_suffix}", "")
          contract_consumers          = try([for contract in epg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_providers          = try([for contract in epg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_imported_consumers = try([for contract in epg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
          contract_intra_epgs         = try([for contract in epg.contracts.intra_epgs : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          physical_domains            = try([for domain in epg.physical_domains : "${domain}${local.defaults.apic.access_policies.physical_domains.name_suffix}"], [])
          contract_masters = [for master in try(epg.contracts.masters, []) : {
            endpoint_group      = master.endpoint_group
            application_profile = try(master.application_profile, "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}")
          }]
          subnets = [for subnet in try(epg.subnets, []) : {
            description           = try(subnet.description, "")
            ip                    = subnet.ip
            public                = try(subnet.public, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.public)
            shared                = try(subnet.shared, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.shared)
            igmp_querier          = try(subnet.igmp_querier, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.igmp_querier)
            nd_ra_prefix          = try(subnet.nd_ra_prefix, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.nd_ra_prefix)
            no_default_gateway    = try(subnet.no_default_gateway, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.no_default_gateway)
            nd_ra_prefix_policy   = try("${subnet.nd_ra_prefix_policy}${local.defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix}", "")
            ip_dataplane_learning = try(subnet.ip_dataplane_learning, null)
            next_hop_ip           = try(subnet.next_hop_ip, "")
            anycast_mac           = try(subnet.anycast_mac, "")
            nlb_group             = try(subnet.nlb_group, "0.0.0.0")
            nlb_mac               = try(subnet.nlb_mac, "00:00:00:00:00:00")
            nlb_mode              = try(subnet.nlb_mode, "")
            ip_pools = [for pool in try(subnet.ip_pools, []) : {
              name              = "${pool.name}${local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.ip_pools.name_suffix}"
              start_ip          = try(pool.start_ip, "0.0.0.0")
              end_ip            = try(pool.end_ip, "0.0.0.0")
              dns_search_suffix = try(pool.dns_search_suffix, "")
              dns_server        = try(pool.dns_server, "")
              dns_suffix        = try(pool.dns_suffix, "")
              wins_server       = try(pool.wins_server, "")
            }]
          }]
          vmware_vmm_domains = [for vmm in try(epg.vmware_vmm_domains, []) : {
            name                 = "${vmm.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}"
            u_segmentation       = try(vmm.u_segmentation, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.u_segmentation)
            delimiter            = try(vmm.delimiter, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.delimiter)
            vlan                 = try(vmm.vlan, null)
            primary_vlan         = try(vmm.primary_vlan, null)
            secondary_vlan       = try(vmm.secondary_vlan, null)
            netflow              = try(vmm.netflow, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.netflow)
            deployment_immediacy = try(vmm.deployment_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.deployment_immediacy)
            resolution_immediacy = try(vmm.resolution_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.resolution_immediacy)
            port_binding         = try(vmm.port_binding, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.port_binding)
            allow_promiscuous    = try(vmm.allow_promiscuous, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.allow_promiscuous) == "accept" ? true : false
            forged_transmits     = try(vmm.forged_transmits, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.forged_transmits) == "accept" ? true : false
            mac_changes          = try(vmm.mac_changes, local.defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.mac_changes) == "accept" ? true : false
            custom_epg_name      = try(vmm.custom_epg_name, "")
            elag                 = try(vmm.elag, "")
            active_uplinks_order = try(vmm.active_uplinks_order, "")
            standby_uplinks      = try(vmm.standby_uplinks, "")
          }]
          nutanix_vmm_domains = [for vmm in try(epg.nutanix_vmm_domains, []) : {
            name                         = "${vmm.name}${local.defaults.apic.fabric_policies.nutanix_vmm_domains.name_suffix}"
            vlan                         = try(vmm.vlan, null)
            deployment_immediacy         = try(vmm.deployment_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.nutanix_vmm_domains.deployment_immediacy)
            custom_epg_name              = try(vmm.custom_epg_name, "")
            gateway_address              = try(vmm.ipam.gateway_address, local.defaults.apic.tenants.application_profiles.endpoint_groups.nutanix_vmm_domains.ipam.gateway_address)
            dhcp_server_address_override = try(vmm.ipam.dhcp_server_address_override, local.defaults.apic.tenants.application_profiles.endpoint_groups.nutanix_vmm_domains.ipam.dhcp_server_address_override)
            dhcp_address_pool            = try(vmm.ipam.dhcp_address_pool, "")
          }]
          static_ports = [for sp in try(epg.static_ports, []) : {
            node_id = try(sp.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == sp.channel][0][0], null)
            # set node2_id to "vpc" if channel IPG is vPC, otherwise "null"
            description          = try(sp.description, "")
            node2_id             = try(sp.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == sp.channel && pg.type == "vpc"][0], null)
            fex_id               = try(sp.fex_id, null)
            fex2_id              = try(sp.fex2_id, null)
            pod_id               = try(sp.pod_id, null)
            channel              = try("${sp.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
            port                 = try(sp.port, null)
            sub_port             = try(sp.sub_port, null)
            module               = try(sp.module, null)
            vlan                 = try(sp.vlan, null)
            primary_vlan         = try(sp.primary_vlan, null)
            deployment_immediacy = try(sp.deployment_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.deployment_immediacy)
            mode                 = try(sp.mode, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.mode)
            ptp_source_ip        = try(sp.ptp.source_ip, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.ptp.source_ip)
            ptp_mode             = try(sp.ptp.mode, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.ptp.mode)
            ptp_profile          = try(sp.ptp.profile, null)
          }]
          static_leafs = [for sl in try(epg.static_leafs, []) : {
            pod_id               = try(sl.pod_id, null)
            node_id              = try(sl.node_id, null)
            vlan                 = try(sl.vlan, null)
            mode                 = try(sl.mode, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_leafs.mode)
            deployment_immediacy = try(sl.deployment_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_leafs.deployment_immediacy)
          }]
          static_endpoints = [for se in try(epg.static_endpoints, []) : {
            name    = try("${se.name}${local.defaults.apic.tenants.application_profiles.endpoint_groups.static_endpoints.name_suffix}", "")
            alias   = try(se.alias, "")
            mac     = se.mac
            ip      = try(se.ip, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_endpoints.ip)
            type    = se.type
            node_id = try(se.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == se.channel][0][0], null)
            # set node2_id to "vpc" if channel IPG is vPC, otherwise "null"
            node2_id       = try(se.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == se.channel && pg.type == "vpc"][0], null)
            pod_id         = try(se.pod_id, null)
            channel        = try("${se.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
            port           = try(se.port, null)
            module         = try(se.module, 1)
            vlan           = try(se.vlan, null)
            additional_ips = try(se.additional_ips, [])
          }]
          static_aaeps = [for sa in try(epg.static_aaeps, []) : {
            name                 = "${sa.name}${local.defaults.apic.access_policies.aaeps.name_suffix}"
            encap                = sa.encap
            primary_encap        = try(sa.primary_encap, null)
            mode                 = try(sa.mode, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_aaeps.mode)
            deployment_immediacy = try(sa.deployment_immediacy, local.defaults.apic.tenants.application_profiles.endpoint_groups.static_aaeps.deployment_immediacy)
          }]
          l4l7_virtual_ips = [for vip in try(epg.l4l7_virtual_ips, []) : {
            ip          = vip.ip
            description = try(vip.description, "")
          }]
          l4l7_address_pools = [for ap in try(epg.l4l7_address_pools, []) : {
            name            = ap.name
            gateway_address = ap.gateway_address
            from            = try(ap.from, "")
            to              = try(ap.to, "")
          }]
        }
      ]
    ]
  ])
}

module "aci_endpoint_group" {
  source = "./modules/terraform-aci-endpoint-group"

  for_each                    = { for epg in local.endpoint_groups : epg.key => epg if local.modules.aci_endpoint_group && var.manage_tenants }
  bulk_static_ports           = try(local.apic.bulk_static_ports, local.defaults.apic.bulk_static_ports)
  tenant                      = each.value.tenant
  application_profile         = each.value.application_profile
  name                        = each.value.name
  annotation                  = each.value.annotation
  alias                       = each.value.alias
  description                 = each.value.description
  flood_in_encap              = each.value.flood_in_encap
  intra_epg_isolation         = each.value.intra_epg_isolation
  proxy_arp                   = each.value.proxy_arp
  preferred_group             = each.value.preferred_group
  qos_class                   = each.value.qos_class
  custom_qos_policy           = each.value.custom_qos_policy
  bridge_domain               = each.value.bridge_domain
  data_plane_policing_policy  = each.value.data_plane_policing_policy
  tags                        = each.value.tags
  trust_control_policy        = each.value.trust_control_policy
  contract_consumers          = each.value.contract_consumers
  contract_providers          = each.value.contract_providers
  contract_imported_consumers = each.value.contract_imported_consumers
  contract_intra_epgs         = each.value.contract_intra_epgs
  contract_masters            = each.value.contract_masters
  physical_domains            = each.value.physical_domains
  subnets                     = each.value.subnets
  vmware_vmm_domains          = each.value.vmware_vmm_domains
  nutanix_vmm_domains         = each.value.nutanix_vmm_domains
  static_ports = [for sp in try(each.value.static_ports, []) : {
    description          = sp.description
    node_id              = sp.node_id
    node2_id             = sp.node2_id == "vpc" ? [for pg in local.leaf_interface_policy_group_mapping : try(pg.node_ids, []) if pg.name == sp.channel][0][1] : sp.node2_id
    fex_id               = sp.fex_id
    fex2_id              = sp.fex2_id
    pod_id               = sp.pod_id == null ? try([for node in try(local.node_policies.nodes, []) : node.pod if node.id == sp.node_id][0], local.defaults.apic.node_policies.nodes.pod) : sp.pod_id
    channel              = sp.channel
    port                 = sp.port
    sub_port             = sp.sub_port
    module               = sp.module
    vlan                 = sp.vlan
    primary_vlan         = sp.primary_vlan
    deployment_immediacy = sp.deployment_immediacy
    mode                 = sp.mode
    ptp_source_ip        = sp.ptp_source_ip
    ptp_mode             = sp.ptp_mode
    ptp_profile          = sp.ptp_profile
  }]
  static_leafs = [for sl in try(each.value.static_leafs, []) : {
    pod_id               = sl.pod_id == null ? try([for node in try(local.node_policies.nodes, []) : node.pod if node.id == sl.node_id][0], local.defaults.apic.node_policies.nodes.pod) : sl.pod_id
    node_id              = sl.node_id
    vlan                 = sl.vlan
    mode                 = sl.mode
    deployment_immediacy = sl.deployment_immediacy
  }]
  static_endpoints = [for se in try(each.value.static_endpoints, []) : {
    name           = se.name
    alias          = se.alias
    mac            = se.mac
    ip             = se.ip
    type           = se.type
    node_id        = se.node_id
    node2_id       = se.node2_id == "vpc" ? [for pg in local.leaf_interface_policy_group_mapping : try(pg.node_ids, []) if pg.name == se.channel][0][1] : se.node2_id
    pod_id         = se.pod_id == null ? try([for node in try(local.node_policies.nodes, []) : node.pod if node.id == se.node_id][0], local.defaults.apic.node_policies.nodes.pod) : se.pod_id
    channel        = se.channel
    port           = se.port
    module         = se.module
    vlan           = se.vlan
    additional_ips = se.additional_ips
  }]
  static_aaeps = [for sa in try(each.value.static_aaeps, []) : {
    name                 = sa.name
    encap                = sa.encap
    primary_encap        = sa.primary_encap
    mode                 = sa.mode
    deployment_immediacy = sa.deployment_immediacy
  }]
  l4l7_virtual_ips   = each.value.l4l7_virtual_ips
  l4l7_address_pools = each.value.l4l7_address_pools

  depends_on = [
    module.aci_tenant,
    module.aci_application_profile,
    module.aci_bridge_domain,
    module.aci_data_plane_policing_policy,
    module.aci_contract,
    module.aci_imported_contract,
    module.aci_vmware_vmm_domain,
    module.aci_vlan_pool,
  ]
}

locals {
  useg_endpoint_groups = flatten([
    for tenant in local.tenants : [
      for ap in try(tenant.application_profiles, []) : [
        for useg_epg in try(ap.useg_endpoint_groups, []) : {
          key                         = format("%s/%s/%s", tenant.name, ap.name, useg_epg.name)
          tenant                      = tenant.name
          application_profile         = "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}"
          name                        = "${useg_epg.name}${local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.name_suffix}"
          alias                       = try(useg_epg.alias, "")
          description                 = try(useg_epg.description, "")
          flood_in_encap              = try(useg_epg.flood_in_encap, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.flood_in_encap)
          intra_epg_isolation         = try(useg_epg.intra_epg_isolation, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.intra_epg_isolation)
          preferred_group             = try(useg_epg.preferred_group, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.preferred_group)
          qos_class                   = try(useg_epg.qos_class, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.qos_class)
          custom_qos_policy           = try("${useg_epg.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
          bridge_domain               = try("${useg_epg.bridge_domain}${local.defaults.apic.tenants.bridge_domains.name_suffix}", "")
          tags                        = try(useg_epg.tags, [])
          trust_control_policy        = try("${useg_epg.trust_control_policy}${local.defaults.apic.tenants.policies.trust_control_policies.name_suffix}", "")
          contract_consumers          = try([for contract in useg_epg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_providers          = try([for contract in useg_epg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_imported_consumers = try([for contract in useg_epg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
          contract_intra_epgs         = try([for contract in useg_epg.contracts.intra_epgs : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          physical_domains            = try([for domain in useg_epg.physical_domains : "${domain}${local.defaults.apic.access_policies.physical_domains.name_suffix}"], [])
          useg_attributes_match_type  = try(useg_epg.useg_attributes.match_type, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.match_type)
          contract_masters = [for master in try(useg_epg.contracts.masters, []) : {
            endpoint_group      = master.endpoint_group
            application_profile = try(master.application_profile, "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}")
          }]
          useg_attributes_ip_statements = [for ip_statement in try(useg_epg.useg_attributes.ip_statements, []) : {
            name           = ip_statement.name
            use_epg_subnet = try(ip_statement.use_epg_subnet, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.ip_statements.use_epg_subnet)
            ip             = try(ip_statement.ip, "")
          }]
          useg_attributes_mac_statements = [for mac_statement in try(useg_epg.useg_attributes.mac_statements, []) : {
            name = mac_statement.name
            mac  = upper(mac_statement.mac)
          }]
          useg_attributes_vm_statements = [for vm_statement in try(useg_epg.useg_attributes.vm_statements, []) : {
            name     = vm_statement.name
            type     = try(vm_statement.type, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.vm_statements.type)
            operator = try(vm_statement.operator, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.vm_statements.operator)
            value    = vm_statement.value
            category = try(vm_statement.category, null)
            label    = try(vm_statement.label, null)
          }]
          subnets = [for subnet in try(useg_epg.subnets, []) : {
            description         = try(subnet.description, "")
            ip                  = subnet.ip
            public              = try(subnet.public, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.public)
            shared              = try(subnet.shared, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.shared)
            igmp_querier        = try(subnet.igmp_querier, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.igmp_querier)
            nd_ra_prefix        = try(subnet.nd_ra_prefix, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.nd_ra_prefix)
            no_default_gateway  = try(subnet.no_default_gateway, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.no_default_gateway)
            nd_ra_prefix_policy = try("${subnet.nd_ra_prefix_policy}${local.defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix}", "")
            next_hop_ip         = try(subnet.next_hop_ip, "")
            anycast_mac         = try(subnet.anycast_mac, "")
            nlb_group           = try(subnet.nlb_group, "0.0.0.0")
            nlb_mac             = try(subnet.nlb_mac, "00:00:00:00:00:00")
            nlb_mode            = try(subnet.nlb_mode, "")
            ip_pools = [for pool in try(subnet.ip_pools, []) : {
              name              = "${pool.name}${local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.ip_pools.name_suffix}"
              start_ip          = try(pool.start_ip, "0.0.0.0")
              end_ip            = try(pool.end_ip, "0.0.0.0")
              dns_search_suffix = try(pool.dns_search_suffix, "")
              dns_server        = try(pool.dns_server, "")
              dns_suffix        = try(pool.dns_suffix, "")
              wins_server       = try(pool.wins_server, "")
            }]
          }]
          vmware_vmm_domains = [for vmm in try(useg_epg.vmware_vmm_domains, []) : {
            name                 = "${vmm.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}"
            deployment_immediacy = try(vmm.deployment_immediacy, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.deployment_immediacy)
            port_binding         = try(vmm.port_binding, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.port_binding)
            netflow              = try(vmm.netflow, local.defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.netflow)
            elag                 = try(vmm.elag, "")
            active_uplinks_order = try(vmm.active_uplinks_order, "")
            standby_uplinks      = try(vmm.standby_uplinks, "")
          }]
          static_leafs = [for sl in try(useg_epg.static_leafs, []) : {
            pod_id  = try(sl.pod_id, null)
            node_id = try(sl.node_id, null)
          }]
          l4l7_address_pools = [for ap in try(useg_epg.l4l7_address_pools, []) : {
            name            = ap.name
            gateway_address = ap.gateway_address
            from            = try(ap.from, "")
            to              = try(ap.to, "")
          }]
        }
      ]
    ]
  ])
}

module "aci_useg_endpoint_group" {
  source = "./modules/terraform-aci-useg-endpoint-group"

  for_each                    = { for epg in local.useg_endpoint_groups : epg.key => epg if local.modules.aci_useg_endpoint_group && var.manage_tenants }
  tenant                      = each.value.tenant
  application_profile         = each.value.application_profile
  name                        = each.value.name
  alias                       = each.value.alias
  description                 = each.value.description
  flood_in_encap              = each.value.flood_in_encap
  intra_epg_isolation         = each.value.intra_epg_isolation
  preferred_group             = each.value.preferred_group
  qos_class                   = each.value.qos_class
  custom_qos_policy           = each.value.custom_qos_policy
  bridge_domain               = each.value.bridge_domain
  tags                        = each.value.tags
  trust_control_policy        = each.value.trust_control_policy
  contract_consumers          = each.value.contract_consumers
  contract_providers          = each.value.contract_providers
  contract_imported_consumers = each.value.contract_imported_consumers
  contract_intra_epgs         = each.value.contract_intra_epgs
  contract_masters            = each.value.contract_masters
  physical_domains            = each.value.physical_domains
  match_type                  = each.value.useg_attributes_match_type
  ip_statements               = each.value.useg_attributes_ip_statements
  mac_statements              = each.value.useg_attributes_mac_statements
  vm_statements               = each.value.useg_attributes_vm_statements
  subnets                     = each.value.subnets
  vmware_vmm_domains          = each.value.vmware_vmm_domains
  static_leafs = [for sl in try(each.value.static_leafs, []) : {
    pod_id  = sl.pod_id == null ? try([for node in try(local.node_policies.nodes, []) : node.pod if node.id == sl.node_id][0], local.defaults.apic.node_policies.nodes.pod) : sl.pod_id
    node_id = sl.node_id
  }]
  l4l7_address_pools = each.value.l4l7_address_pools

  depends_on = [
    module.aci_tenant,
    module.aci_application_profile,
    module.aci_endpoint_group,
    module.aci_bridge_domain,
    module.aci_contract,
    module.aci_imported_contract,
    module.aci_vmware_vmm_domain,
  ]
}

locals {
  endpoint_security_groups = flatten([
    for tenant in local.tenants : [
      for ap in try(tenant.application_profiles, []) : [
        for esg in try(ap.endpoint_security_groups, []) : {
          key                         = format("%s/%s/%s", tenant.name, ap.name, esg.name)
          tenant                      = tenant.name
          application_profile         = "${ap.name}${local.defaults.apic.tenants.application_profiles.name_suffix}"
          name                        = "${esg.name}${local.defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix}"
          description                 = try(esg.description, "")
          vrf                         = "${esg.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}"
          shutdown                    = try(esg.shutdown, local.defaults.apic.tenants.application_profiles.endpoint_security_groups.shutdown)
          deployment_immediacy        = try(esg.deployment_immediacy, null)
          intra_esg_isolation         = try(esg.intra_esg_isolation, local.defaults.apic.tenants.application_profiles.endpoint_security_groups.intra_esg_isolation)
          preferred_group             = try(esg.preferred_group, local.defaults.apic.tenants.application_profiles.endpoint_security_groups.preferred_group)
          contract_consumers          = try([for contract in esg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_providers          = try([for contract in esg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_imported_consumers = try([for contract in esg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
          contract_intra_esgs         = try([for contract in esg.contracts.intra_esgs : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          esg_contract_masters = [for master in try(esg.contracts.masters, []) : {
            tenant                  = tenant.name
            application_profile     = "${try(master.application_profile, ap.name)}${local.defaults.apic.tenants.application_profiles.name_suffix}"
            endpoint_security_group = "${master.endpoint_security_group}${local.defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix}"
          }]
          tag_selectors = [for sel in try(esg.tag_selectors, []) : {
            key         = sel.key
            operator    = try(sel.operator, local.defaults.apic.tenants.application_profiles.endpoint_security_groups.tag_selectors.operator)
            value       = sel.value
            description = try(sel.description, "")
          }]
          epg_selectors = [for sel in try(esg.epg_selectors, []) : {
            tenant              = tenant.name
            application_profile = "${try(sel.application_profile, ap.name)}${local.defaults.apic.tenants.application_profiles.name_suffix}"
            endpoint_group      = "${sel.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}"
            description         = try(sel.description, "")
          }]
          ip_subnet_selectors = [for sel in try(esg.ip_subnet_selectors, []) : {
            value       = sel.value
            description = try(sel.description, "")
          }]
          ip_external_subnet_selectors = [for sel in try(esg.ip_external_subnet_selectors, []) : {
            ip          = sel.ip
            description = try(sel.description, "")
            shared      = try(sel.shared, local.defaults.apic.tenants.application_profiles.endpoint_security_groups.ip_external_subnet_selectors.shared)
          }]
        }
      ]
    ]
  ])
}

module "aci_endpoint_security_group" {
  source = "./modules/terraform-aci-endpoint-security-group"

  for_each                     = { for esg in local.endpoint_security_groups : esg.key => esg if local.modules.aci_endpoint_security_group && var.manage_tenants }
  tenant                       = each.value.tenant
  application_profile          = each.value.application_profile
  name                         = each.value.name
  description                  = each.value.description
  vrf                          = each.value.vrf
  shutdown                     = each.value.shutdown
  intra_esg_isolation          = each.value.intra_esg_isolation
  preferred_group              = each.value.preferred_group
  contract_consumers           = each.value.contract_consumers
  contract_providers           = each.value.contract_providers
  contract_imported_consumers  = each.value.contract_imported_consumers
  contract_intra_esgs          = each.value.contract_intra_esgs
  esg_contract_masters         = each.value.esg_contract_masters
  tag_selectors                = each.value.tag_selectors
  epg_selectors                = each.value.epg_selectors
  ip_subnet_selectors          = each.value.ip_subnet_selectors
  ip_external_subnet_selectors = each.value.ip_external_subnet_selectors

  depends_on = [
    module.aci_tenant,
    module.aci_application_profile,
    module.aci_vrf,
    module.aci_contract,
    module.aci_endpoint_group,
  ]
}

locals {
  inband_endpoint_groups = flatten([
    for tenant in local.tenants : [
      for epg in try(tenant.inb_endpoint_groups, []) : {
        key                         = format("%s/%s", tenant.name, epg.name)
        name                        = "${epg.name}${local.defaults.apic.tenants.inb_endpoint_groups.name_suffix}"
        vlan                        = epg.vlan
        bridge_domain               = "${epg.bridge_domain}${local.defaults.apic.tenants.bridge_domains.name_suffix}"
        contract_consumers          = try([for contract in epg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
        contract_providers          = try([for contract in epg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
        contract_imported_consumers = try([for contract in epg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
        static_routes               = try(epg.static_routes, [])
        subnets = [for subnet in try(epg.subnets, []) : {
          description = try(subnet.description, "")
          ip          = subnet.ip
          public      = try(subnet.public, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.public)
          shared      = try(subnet.shared, local.defaults.apic.tenants.application_profiles.endpoint_groups.subnets.shared)
        }]
      }
    ] if tenant.name == "mgmt"
  ])
}

module "aci_inband_endpoint_group" {
  source = "./modules/terraform-aci-inband-endpoint-group"

  for_each                    = { for epg in local.inband_endpoint_groups : epg.key => epg if local.modules.aci_inband_endpoint_group && var.manage_tenants }
  name                        = each.value.name
  vlan                        = each.value.vlan
  bridge_domain               = each.value.bridge_domain
  contract_consumers          = each.value.contract_consumers
  contract_providers          = each.value.contract_providers
  contract_imported_consumers = each.value.contract_imported_consumers
  static_routes               = each.value.static_routes
  subnets                     = each.value.subnets
  depends_on = [
    module.aci_tenant,
    module.aci_contract,
    module.aci_imported_contract,
    module.aci_bridge_domain,
  ]
}

locals {
  oob_endpoint_groups = flatten([
    for tenant in local.tenants : [
      for epg in try(tenant.oob_endpoint_groups, []) : {
        key                    = format("%s/%s", tenant.name, try(epg.name, local.defaults.apic.tenants.oob_endpoint_groups.name))
        name                   = try("${epg.name}${local.defaults.apic.tenants.oob_endpoint_groups.name_suffix}", local.defaults.apic.tenants.oob_endpoint_groups.name)
        oob_contract_providers = try([for contract in epg.oob_contracts.providers : "${contract}${local.defaults.apic.tenants.oob_contracts.name_suffix}"], [])
        static_routes          = try(epg.static_routes, [])
      }
    ] if tenant.name == "mgmt"
  ])
}

module "aci_oob_endpoint_group" {
  source = "./modules/terraform-aci-oob-endpoint-group"

  for_each               = { for epg in local.oob_endpoint_groups : epg.key => epg if local.modules.aci_oob_endpoint_group && var.manage_tenants }
  name                   = each.value.name
  oob_contract_providers = each.value.oob_contract_providers
  static_routes          = each.value.static_routes

  depends_on = [
    module.aci_tenant,
    module.aci_oob_contract,
  ]
}

locals {
  external_management_instances = flatten([
    for tenant in local.tenants : [
      for ext in try(tenant.ext_mgmt_instances, []) : {
        key                    = format("%s/%s", tenant.name, ext.name)
        name                   = "${ext.name}${local.defaults.apic.tenants.ext_mgmt_instances.name_suffix}"
        subnets                = try(ext.subnets, [])
        oob_contract_consumers = try([for contract in ext.oob_contracts.consumers : "${contract}${local.defaults.apic.tenants.oob_contracts.name_suffix}"], [])
      }
    ] if tenant.name == "mgmt"
  ])
}

module "aci_oob_external_management_instance" {
  source = "./modules/terraform-aci-oob-external-management-instance"

  for_each               = { for ext in local.external_management_instances : ext.key => ext if local.modules.aci_oob_external_management_instance && var.manage_tenants }
  name                   = each.value.name
  subnets                = each.value.subnets
  oob_contract_consumers = each.value.oob_contract_consumers

  depends_on = [
    module.aci_tenant,
    module.aci_oob_contract,
  ]
}

locals {
  l3outs = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : {
        key         = format("%s/%s", tenant.name, l3out.name)
        tenant      = tenant.name
        name        = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
        annotation  = try(l3out.ndo_managed, local.defaults.apic.tenants.l3outs.ndo_managed) ? "orchestrator:msc-shadow:no" : null
        alias       = try(l3out.alias, "")
        description = try(l3out.description, "")
        multipod    = try(l3out.multipod, local.defaults.apic.tenants.l3outs.multipod)
        domain      = "${l3out.domain}${local.defaults.apic.access_policies.routed_domains.name_suffix}"
        vrf         = "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}"
        bgp = anytrue([
          anytrue([
            for np in try(l3out.node_profiles, []) : try(np.bgp_peers, null) != null
          ]),
          anytrue(
            flatten([for np in try(l3out.node_profiles, []) : [
              for ip in try(np.interface_profiles, []) : [
                for int in try(ip.interfaces, []) : try(int.bgp_peers, null) != null
              ]
            ]])
          ),
          try(l3out.bgp_peers, null) != null,
          anytrue(
            flatten([for node in try(l3out.nodes, []) : [
              for int in try(node.interfaces, []) : try(int.bgp_peers, null) != null
            ]])
          ),
        ])
        ospf                                    = try(l3out.ospf, null) != null ? true : false
        ospf_area                               = can(tonumber(try(l3out.ospf.area, "backbone"))) ? (tonumber(try(l3out.ospf.area, "backbone")) == 0 ? "backbone" : tonumber(try(l3out.ospf.area, "backbone"))) : try(l3out.ospf.area, "backbone")
        ospf_area_cost                          = try(l3out.ospf.area_cost, local.defaults.apic.tenants.l3outs.ospf.area_cost)
        ospf_area_type                          = try(l3out.ospf.area_type, local.defaults.apic.tenants.l3outs.ospf.area_type)
        ospf_area_control_redistribute          = try(l3out.ospf.area_control_redistribute, local.defaults.apic.tenants.l3outs.ospf.area_control_redistribute)
        ospf_area_control_summary               = try(l3out.ospf.area_control_summary, local.defaults.apic.tenants.l3outs.ospf.area_control_summary)
        ospf_area_control_suppress_fa           = try(l3out.ospf.area_control_suppress_fa, local.defaults.apic.tenants.l3outs.ospf.area_control_suppress_fa)
        eigrp                                   = try(l3out.eigrp, null) != null ? true : false
        eigrp_asn                               = try(l3out.eigrp, null) != null ? l3out.eigrp.asn : 1
        l3_multicast_ipv4                       = try(l3out.l3_multicast_ipv4, local.defaults.apic.tenants.l3outs.l3_multicast_ipv4)
        target_dscp                             = try(l3out.target_dscp, local.defaults.apic.tenants.l3outs.target_dscp)
        import_route_control_enforcement        = try(l3out.import_route_control_enforcement, local.defaults.apic.tenants.l3outs.import_route_control_enforcement)
        export_route_control_enforcement        = try(l3out.export_route_control_enforcement, local.defaults.apic.tenants.l3outs.export_route_control_enforcement)
        interleak_route_map                     = try("${l3out.interleak_route_map}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", "")
        dampening_ipv4_route_map                = try("${l3out.dampening_ipv4_route_map}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", "")
        dampening_ipv6_route_map                = try("${l3out.dampening_ipv6_route_map}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", "")
        default_route_leak_policy               = try(l3out.default_route_leak_policy, null) != null ? true : false
        default_route_leak_policy_always        = try(l3out.default_route_leak_policy.always, local.defaults.apic.tenants.l3outs.default_route_leak_policy.always)
        default_route_leak_policy_criteria      = try(l3out.default_route_leak_policy.criteria, local.defaults.apic.tenants.l3outs.default_route_leak_policy.criteria)
        default_route_leak_policy_context_scope = try(l3out.default_route_leak_policy.context_scope, local.defaults.apic.tenants.l3outs.default_route_leak_policy.context_scope)
        default_route_leak_policy_outside_scope = try(l3out.default_route_leak_policy.outside_scope, local.defaults.apic.tenants.l3outs.default_route_leak_policy.outside_scope)
        redistribution_route_maps = [for routemap in try(l3out.redistribution_route_maps, []) : {
          source    = try(routemap.source, local.defaults.apic.tenants.l3outs.redistribution_route_maps.source)
          route_map = "${routemap.route_map}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}"
        }]
        import_route_map_name        = try(l3out.import_route_map.name, "default-import")
        import_route_map_description = try(l3out.import_route_map.description, "")
        import_route_map_type        = try(l3out.import_route_map.type, local.defaults.apic.tenants.l3outs.import_route_map.type)
        import_route_map_contexts = [for context in try(l3out.import_route_map.contexts, []) : {
          name        = "${context.name}${local.defaults.apic.tenants.l3outs.import_route_map.contexts.name_suffix}"
          description = try(context.description, "")
          action      = try(context.action, local.defaults.apic.tenants.l3outs.import_route_map.contexts.action)
          order       = try(context.order, local.defaults.apic.tenants.l3outs.import_route_map.contexts.order)
          set_rule    = try("${context.set_rule}${local.defaults.apic.tenants.policies.set_rules.name_suffix}", "")
          match_rules = [for rule in try(context.match_rules, []) : "${rule}${local.defaults.apic.tenants.policies.match_rules.name_suffix}"]
        }]
        export_route_map_name        = try(l3out.export_route_map.name, "default-export")
        export_route_map_description = try(l3out.export_route_map.description, "")
        export_route_map_type        = try(l3out.export_route_map.type, local.defaults.apic.tenants.l3outs.export_route_map.type)
        export_route_map_contexts = [for context in try(l3out.export_route_map.contexts, []) : {
          name        = "${context.name}${local.defaults.apic.tenants.l3outs.export_route_map.contexts.name_suffix}"
          description = try(context.description, "")
          action      = try(context.action, local.defaults.apic.tenants.l3outs.export_route_map.contexts.action)
          order       = try(context.order, local.defaults.apic.tenants.l3outs.export_route_map.contexts.order)
          set_rule    = try("${context.set_rule}${local.defaults.apic.tenants.policies.set_rules.name_suffix}", "")
          match_rules = [for rule in try(context.match_rules, []) : "${rule}${local.defaults.apic.tenants.policies.match_rules.name_suffix}"]
        }]
        route_maps = [for route_map in try(l3out.route_maps, []) : {
          name        = "${route_map.name}${local.defaults.apic.tenants.l3outs.route_maps.name_suffix}"
          description = try(route_map.description, "")
          type        = try(route_map.type, local.defaults.apic.tenants.l3outs.route_maps.type)
          contexts = [for context in try(route_map.contexts, []) : {
            name        = "${context.name}${local.defaults.apic.tenants.l3outs.route_maps.contexts.name_suffix}"
            description = try(context.description, "")
            action      = try(context.action, local.defaults.apic.tenants.l3outs.route_maps.contexts.action)
            order       = try(context.order, local.defaults.apic.tenants.l3outs.route_maps.contexts.order)
            set_rule    = try("${context.set_rule}${local.defaults.apic.tenants.policies.set_rules.name_suffix}", "")
            match_rules = [for rule in try(context.match_rules, []) : "${rule}${local.defaults.apic.tenants.policies.match_rules.name_suffix}"]
            }
          ]
          }
        ]
      }
    ]
  ])
}

module "aci_l3out" {
  source = "./modules/terraform-aci-l3out"

  for_each                                = { for l3out in local.l3outs : l3out.key => l3out if local.modules.aci_l3out && var.manage_tenants }
  tenant                                  = each.value.tenant
  name                                    = each.value.name
  annotation                              = each.value.annotation
  alias                                   = each.value.alias
  description                             = each.value.description
  multipod                                = each.value.multipod
  routed_domain                           = each.value.domain
  vrf                                     = each.value.vrf
  bgp                                     = each.value.bgp
  ospf                                    = each.value.ospf
  ospf_area                               = each.value.ospf_area
  ospf_area_cost                          = each.value.ospf_area_cost
  ospf_area_type                          = each.value.ospf_area_type
  ospf_area_control_redistribute          = each.value.ospf_area_control_redistribute
  ospf_area_control_summary               = each.value.ospf_area_control_summary
  ospf_area_control_suppress_fa           = each.value.ospf_area_control_suppress_fa
  eigrp                                   = each.value.eigrp
  eigrp_asn                               = each.value.eigrp_asn
  l3_multicast_ipv4                       = each.value.l3_multicast_ipv4
  target_dscp                             = each.value.target_dscp
  import_route_control_enforcement        = each.value.import_route_control_enforcement
  export_route_control_enforcement        = each.value.export_route_control_enforcement
  interleak_route_map                     = each.value.interleak_route_map
  dampening_ipv4_route_map                = each.value.dampening_ipv4_route_map
  dampening_ipv6_route_map                = each.value.dampening_ipv6_route_map
  default_route_leak_policy               = each.value.default_route_leak_policy
  default_route_leak_policy_always        = each.value.default_route_leak_policy_always
  default_route_leak_policy_criteria      = each.value.default_route_leak_policy_criteria
  default_route_leak_policy_context_scope = each.value.default_route_leak_policy_context_scope
  default_route_leak_policy_outside_scope = each.value.default_route_leak_policy_outside_scope
  redistribution_route_maps               = each.value.redistribution_route_maps
  import_route_map_name                   = each.value.import_route_map_name
  import_route_map_description            = each.value.import_route_map_description
  import_route_map_type                   = each.value.import_route_map_type
  import_route_map_contexts               = each.value.import_route_map_contexts
  export_route_map_name                   = each.value.export_route_map_name
  export_route_map_description            = each.value.export_route_map_description
  export_route_map_type                   = each.value.export_route_map_type
  export_route_map_contexts               = each.value.export_route_map_contexts
  route_maps                              = each.value.route_maps

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
    module.aci_ospf_interface_policy,
    module.aci_eigrp_interface_policy,
    module.aci_bfd_interface_policy,
    module.aci_match_rule,
  ]
}

locals {
  node_profiles_manual = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : [
        for np in try(l3out.node_profiles, []) : {
          key                       = format("%s/%s/%s", tenant.name, l3out.name, np.name)
          tenant                    = tenant.name
          l3out                     = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
          name                      = "${np.name}${local.defaults.apic.tenants.l3outs.node_profiles.name_suffix}"
          multipod                  = try(l3out.multipod, local.defaults.apic.tenants.l3outs.multipod)
          remote_leaf               = try(l3out.remote_leaf, local.defaults.apic.tenants.l3outs.remote_leaf)
          bgp_protocol_profile_name = try(np.bgp.name, "")
          bgp_timer_policy          = try("${np.bgp.timer_policy}${local.defaults.apic.tenants.policies.bgp_timer_policies.name_suffix}", "")
          bgp_as_path_policy        = try("${np.bgp.as_path_policy}${local.defaults.apic.tenants.policies.bgp_best_path_policies.name_suffix}", "")
          bfd_multihop_node_policy  = try("${np.bfd_multihop_node_policy}${local.defaults.apic.tenants.policies.bfd_multihop_node_policies.name_suffix}", "")
          bfd_multihop_auth_key_id  = try(np.bfd_multihop_auth.key_id, local.defaults.apic.tenants.l3outs.node_profiles.bfd_multihop_auth.key_id)
          bfd_multihop_auth_key     = try(np.bfd_multihop_auth.key, null)
          bfd_multihop_auth_type    = try(np.bfd_multihop_auth.type, local.defaults.apic.tenants.l3outs.node_profiles.bfd_multihop_auth.type)
          nodes = [for node in try(np.nodes, []) : {
            node_id               = node.node_id
            pod_id                = try(node.pod_id, [for node_ in local.node_policies.nodes : node_.pod if node_.id == node.node_id][0], local.defaults.apic.tenants.l3outs.node_profiles.nodes.pod)
            router_id             = node.router_id
            router_id_as_loopback = try(node.router_id_as_loopback, local.defaults.apic.tenants.l3outs.node_profiles.nodes.router_id_as_loopback)
            loopbacks             = try(node.loopbacks, [])
            static_routes = [for sr in try(node.static_routes, []) : {
              description = try(sr.description, "")
              prefix      = sr.prefix
              preference  = try(sr.preference, local.defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.preference)
              bfd         = try(sr.bfd, local.defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.bfd)
              track_list  = try("${sr.track_list}${local.defaults.apic.tenants.policies.track_lists.name_suffix}", null)
              next_hops = [for nh in length(try(sr.next_hops, [])) > 0 ? try(sr.next_hops, []) : [{
                ip            = "0.0.0.0/0",
                type          = "none",
                description   = null,
                preference    = 0,
                ip_sla_policy = null,
                track_list    = null
                }] : {
                ip            = nh.ip
                description   = try(nh.description, "")
                preference    = try(nh.preference, local.defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.preference)
                type          = try(nh.type, local.defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.next_hops.type)
                ip_sla_policy = try("${nh.ip_sla_policy}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}", null)
                track_list    = try(nh.ip_sla_policy, null) != null ? "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${nh.ip}" : try("${nh.track_list}${local.defaults.apic.tenants.policies.track_lists.name_suffix}", null)
              }]
            }]
          }]
          bgp_peers = [for peer in try(np.bgp_peers, []) : {
            ip                               = peer.ip
            remote_as                        = peer.remote_as
            description                      = try(peer.description, "")
            allow_self_as                    = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.allow_self_as)
            as_override                      = try(peer.as_override, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.as_override)
            disable_peer_as_check            = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.disable_peer_as_check)
            next_hop_self                    = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.next_hop_self)
            send_community                   = try(peer.send_community, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.send_community)
            send_ext_community               = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.send_ext_community)
            password                         = try(peer.password, null)
            allowed_self_as_count            = try(peer.allowed_self_as_count, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.allowed_self_as_count)
            bfd                              = try(peer.bfd, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.bfd)
            disable_connected_check          = try(peer.disable_connected_check, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.disable_connected_check)
            ttl                              = try(peer.ttl, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.ttl)
            weight                           = try(peer.weight, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.weight)
            remove_all_private_as            = try(peer.remove_all_private_as, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.remove_all_private_as)
            remove_private_as                = try(peer.remove_private_as, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.remove_private_as)
            replace_private_as_with_local_as = try(peer.replace_private_as_with_local_as, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.replace_private_as_with_local_as)
            unicast_address_family           = try(peer.unicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.unicast_address_family)
            multicast_address_family         = try(peer.multicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.multicast_address_family)
            admin_state                      = try(peer.admin_state, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.admin_state)
            local_as                         = try(peer.local_as, null)
            as_propagate                     = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.node_profiles.bgp_peers.as_propagate)
            peer_prefix_policy               = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
            export_route_control             = try("${peer.export_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
            import_route_control             = try("${peer.import_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
          } if tenant.name != "infra"]
          bgp_infra_peers = [for peer in try(np.bgp_infra_peers, []) : {
            ip                    = peer.ip
            remote_as             = peer.remote_as
            admin_state           = try(peer.admin_state, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.admin_state)
            description           = try(peer.description, "")
            allow_self_as         = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.allow_self_as)
            disable_peer_as_check = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.disable_peer_as_check)
            as_override           = try(peer.as_override, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.as_override)
            next_hop_self         = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.next_hop_self)
            send_community        = try(peer.send_community, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.send_community)
            send_ext_community    = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.send_ext_community)
            peer_type             = try(peer.peer_type, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.peer_type)
            bfd                   = try(peer.bfd, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.bfd)
            password              = try(peer.password, null)
            ttl                   = try(peer.ttl, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.ttl)
            local_as              = try(peer.local_as, null)
            as_propagate          = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.as_propagate)
            source_interface_type = try(peer.peer_type, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.peer_type) == "wan" ? try(peer.source_interface_type, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.source_interface_type) : null
            data_plane_address    = try(peer.peer_type, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.peer_type) == "wan" && try(peer.source_interface_type, local.defaults.apic.tenants.l3outs.node_profiles.bgp_infra_peers.source_interface_type) == "routable-loopback" ? try(peer.data_plane_address, null) : null
            peer_prefix_policy    = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
          } if tenant.name == "infra"]
        }
      ]
    ]
  ])
}

module "aci_l3out_node_profile_manual" {
  source = "./modules/terraform-aci-l3out-node-profile"

  for_each                  = { for np in local.node_profiles_manual : np.key => np if local.modules.aci_l3out_node_profile && var.manage_tenants }
  tenant                    = each.value.tenant
  l3out                     = each.value.l3out
  name                      = each.value.name
  multipod                  = each.value.multipod
  remote_leaf               = each.value.remote_leaf
  bgp_protocol_profile_name = each.value.bgp_protocol_profile_name
  bgp_timer_policy          = each.value.bgp_timer_policy
  bgp_as_path_policy        = each.value.bgp_as_path_policy
  nodes                     = each.value.nodes
  bgp_peers                 = each.value.bgp_peers
  bgp_infra_peers           = each.value.bgp_infra_peers
  bfd_multihop_node_policy  = each.value.bfd_multihop_node_policy
  bfd_multihop_auth_key_id  = each.value.bfd_multihop_auth_key_id
  bfd_multihop_auth_key     = each.value.bfd_multihop_auth_key
  bfd_multihop_auth_type    = each.value.bfd_multihop_auth_type

  depends_on = [
    module.aci_tenant,
    module.aci_l3out,
    module.aci_track_list,
  ]
}

locals {
  node_profiles_auto = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : {
        key                       = format("%s/%s", tenant.name, l3out.name)
        tenant                    = tenant.name
        l3out                     = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
        name                      = "${l3out.name}${local.defaults.apic.tenants.l3outs.node_profiles.name_suffix}"
        multipod                  = try(l3out.multipod, local.defaults.apic.tenants.l3outs.multipod)
        remote_leaf               = try(l3out.remote_leaf, local.defaults.apic.tenants.l3outs.remote_leaf)
        bgp_protocol_profile_name = try(l3out.bgp.name, "")
        bgp_timer_policy          = try("${l3out.bgp.timer_policy}${local.defaults.apic.tenants.policies.bgp_timer_policies.name_suffix}", "")
        bgp_as_path_policy        = try("${l3out.bgp.as_path_policy}${local.defaults.apic.tenants.policies.bgp_best_path_policies.name_suffix}", "")
        bfd_multihop_node_policy  = try("${l3out.bfd_multihop_node_policy}${local.defaults.apic.tenants.policies.bfd_multihop_node_policies.name_suffix}", "")
        bfd_multihop_auth_key_id  = try(l3out.bfd_multihop_auth.key_id, local.defaults.apic.tenants.l3outs.bfd_multihop_auth.key_id)
        bfd_multihop_auth_key     = try(l3out.bfd_multihop_auth.key, "")
        bfd_multihop_auth_type    = try(l3out.bfd_multihop_auth.type, local.defaults.apic.tenants.l3outs.bfd_multihop_auth.type)
        nodes = [for node in try(l3out.nodes, []) : {
          node_id               = node.node_id
          pod_id                = try(node.pod_id, [for node_ in local.node_policies.nodes : node_.pod if node_.id == node.node_id][0], local.defaults.apic.tenants.l3outs.nodes.pod)
          router_id             = node.router_id
          router_id_as_loopback = try(node.router_id_as_loopback, local.defaults.apic.tenants.l3outs.nodes.router_id_as_loopback)
          loopbacks             = try(node.loopbacks, [])
          static_routes = [for sr in try(node.static_routes, []) : {
            description = try(sr.description, "")
            prefix      = sr.prefix
            preference  = try(sr.preference, local.defaults.apic.tenants.l3outs.nodes.static_routes.preference)
            bfd         = try(sr.bfd, local.defaults.apic.tenants.l3outs.node_profiles.nodes.static_routes.bfd)
            track_list  = try("${sr.track_list}${local.defaults.apic.tenants.policies.track_lists.name_suffix}", null)
            next_hops = [for nh in length(try(sr.next_hops, [])) > 0 ? try(sr.next_hops, []) : [{
              ip            = "0.0.0.0/0",
              type          = "none",
              description   = null,
              preference    = 0,
              ip_sla_policy = null,
              track_list    = null
              }] : {
              ip            = nh.ip
              description   = try(nh.description, "")
              preference    = try(nh.preference, local.defaults.apic.tenants.l3outs.nodes.static_routes.next_hops.preference)
              type          = try(nh.type, local.defaults.apic.tenants.l3outs.nodes.static_routes.next_hops.type)
              ip_sla_policy = try("${nh.ip_sla_policy}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}", null)
              track_list    = try(nh.ip_sla_policy, null) != null ? "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${nh.ip}" : try("${nh.track_list}${local.defaults.apic.tenants.policies.track_lists.name_suffix}", null)
            }]
          }]
        }]
        bgp_peers = [for peer in try(l3out.bgp_peers, []) : {
          ip                               = peer.ip
          remote_as                        = peer.remote_as
          description                      = try(peer.description, "")
          allow_self_as                    = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.bgp_peers.allow_self_as)
          as_override                      = try(peer.as_override, local.defaults.apic.tenants.l3outs.bgp_peers.as_override)
          disable_peer_as_check            = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.bgp_peers.disable_peer_as_check)
          next_hop_self                    = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.bgp_peers.next_hop_self)
          send_community                   = try(peer.send_community, local.defaults.apic.tenants.l3outs.bgp_peers.send_community)
          send_ext_community               = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.bgp_peers.send_ext_community)
          password                         = try(peer.password, null)
          allowed_self_as_count            = try(peer.allowed_self_as_count, local.defaults.apic.tenants.l3outs.bgp_peers.allowed_self_as_count)
          bfd                              = try(peer.bfd, local.defaults.apic.tenants.l3outs.bgp_peers.bfd)
          disable_connected_check          = try(peer.disable_connected_check, local.defaults.apic.tenants.l3outs.bgp_peers.disable_connected_check)
          ttl                              = try(peer.ttl, local.defaults.apic.tenants.l3outs.bgp_peers.ttl)
          weight                           = try(peer.weight, local.defaults.apic.tenants.l3outs.bgp_peers.weight)
          remove_all_private_as            = try(peer.remove_all_private_as, local.defaults.apic.tenants.l3outs.bgp_peers.remove_all_private_as)
          remove_private_as                = try(peer.remove_private_as, local.defaults.apic.tenants.l3outs.bgp_peers.remove_private_as)
          replace_private_as_with_local_as = try(peer.replace_private_as_with_local_as, local.defaults.apic.tenants.l3outs.bgp_peers.replace_private_as_with_local_as)
          unicast_address_family           = try(peer.unicast_address_family, local.defaults.apic.tenants.l3outs.bgp_peers.unicast_address_family)
          multicast_address_family         = try(peer.multicast_address_family, local.defaults.apic.tenants.l3outs.bgp_peers.multicast_address_family)
          admin_state                      = try(peer.admin_state, local.defaults.apic.tenants.l3outs.bgp_peers.admin_state)
          local_as                         = try(peer.local_as, null)
          as_propagate                     = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.bgp_peers.as_propagate)
          peer_prefix_policy               = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
          export_route_control             = try("${peer.export_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
          import_route_control             = try("${peer.import_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
        } if tenant.name != "infra"]
        bgp_infra_peers = [for peer in try(l3out.bgp_infra_peers, []) : {
          ip                    = peer.ip
          remote_as             = peer.remote_as
          admin_state           = try(peer.admin_state, local.defaults.apic.tenants.l3outs.bgp_infra_peers.admin_state)
          description           = try(peer.description, "")
          allow_self_as         = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.bgp_infra_peers.allow_self_as)
          disable_peer_as_check = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.bgp_infra_peers.disable_peer_as_check)
          as_override           = try(peer.as_override, local.defaults.apic.tenants.l3outs.bgp_infra_peers.as_override)
          next_hop_self         = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.bgp_infra_peers.next_hop_self)
          send_community        = try(peer.send_community, local.defaults.apic.tenants.l3outs.bgp_infra_peers.send_community)
          send_ext_community    = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.bgp_infra_peers.send_ext_community)
          peer_type             = try(peer.peer_type, local.defaults.apic.tenants.l3outs.bgp_infra_peers.peer_type)
          bfd                   = try(peer.bfd, local.defaults.apic.tenants.l3outs.bgp_infra_peers.bfd)
          password              = try(peer.password, null)
          ttl                   = try(peer.ttl, local.defaults.apic.tenants.l3outs.bgp_infra_peers.ttl)
          local_as              = try(peer.local_as, null)
          as_propagate          = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.bgp_infra_peers.as_propagate)
          source_interface_type = try(peer.peer_type, local.defaults.apic.tenants.l3outs.bgp_infra_peers.peer_type) == "wan" ? try(peer.source_interface_type, local.defaults.apic.tenants.l3outs.bgp_infra_peers.source_interface_type) : null
          data_plane_address    = try(peer.peer_type, local.defaults.apic.tenants.l3outs.bgp_infra_peers.peer_type) == "wan" && try(peer.source_interface_type, local.defaults.apic.tenants.l3outs.bgp_infra_peers.source_interface_type) == "routable-loopback" ? try(peer.data_plane_address, null) : null
          peer_prefix_policy    = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
        } if tenant.name == "infra"]
      } if length(try(l3out.nodes, [])) != 0
    ]
  ])
}

module "aci_l3out_node_profile_auto" {
  source = "./modules/terraform-aci-l3out-node-profile"

  for_each                  = { for np in local.node_profiles_auto : np.key => np if local.modules.aci_l3out_node_profile && var.manage_tenants }
  tenant                    = each.value.tenant
  l3out                     = each.value.l3out
  name                      = each.value.name
  multipod                  = each.value.multipod
  remote_leaf               = each.value.remote_leaf
  bgp_protocol_profile_name = each.value.bgp_protocol_profile_name
  bgp_timer_policy          = each.value.bgp_timer_policy
  bgp_as_path_policy        = each.value.bgp_as_path_policy
  nodes                     = each.value.nodes
  bgp_peers                 = each.value.bgp_peers
  bgp_infra_peers           = each.value.bgp_infra_peers
  bfd_multihop_node_policy  = each.value.bfd_multihop_node_policy
  bfd_multihop_auth_key_id  = each.value.bfd_multihop_auth_key_id
  bfd_multihop_auth_key     = each.value.bfd_multihop_auth_key
  bfd_multihop_auth_type    = each.value.bfd_multihop_auth_type

  depends_on = [
    module.aci_tenant,
    module.aci_l3out,
    module.aci_track_list,
  ]
}

locals {
  interface_profiles_manual = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : [
        for np in try(l3out.node_profiles, []) : [
          for ip in try(np.interface_profiles, []) : {
            key                                = format("%s/%s/%s/%s", tenant.name, l3out.name, np.name, ip.name)
            tenant                             = tenant.name
            l3out                              = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
            node_profile                       = "${np.name}${local.defaults.apic.tenants.l3outs.node_profiles.name_suffix}"
            name                               = "${ip.name}${local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.name_suffix}"
            description                        = try(ip.description, "")
            multipod                           = try(l3out.multipod, local.defaults.apic.tenants.l3outs.multipod)
            remote_leaf                        = try(l3out.remote_leaf, local.defaults.apic.tenants.l3outs.remote_leaf)
            bfd_policy                         = try("${ip.bfd_policy}${local.defaults.apic.tenants.policies.bfd_interface_policies.name_suffix}", "")
            ospf_interface_profile_name        = try(ip.ospf.ospf_interface_profile_name, l3out.name)
            ospf_authentication_key            = try(ip.ospf.auth_key, "")
            ospf_authentication_key_id         = try(ip.ospf.auth_key_id, "1")
            ospf_authentication_type           = try(ip.ospf.auth_type, "none")
            ospf_interface_policy              = try(ip.ospf.policy, "")
            eigrp_interface_profile_name       = try(ip.eigrp.interface_profile_name, l3out.name)
            eigrp_interface_policy             = try(ip.eigrp.interface_policy, "")
            eigrp_keychain_policy              = try(ip.eigrp.keychain_policy, "")
            pim_policy                         = try("${ip.pim_policy}${local.defaults.apic.tenants.policies.pim_policies.name_suffix}", "")
            igmp_interface_policy              = try("${ip.igmp_interface_policy}${local.defaults.apic.tenants.policies.igmp_interface_policies.name_suffix}", "")
            nd_interface_policy                = try("${ip.nd_interface_policy}${local.defaults.apic.tenants.policies.nd_interface_policies.name_suffix}", "")
            qos_class                          = try(ip.qos_class, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.qos_class)
            custom_qos_policy                  = try("${ip.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
            egress_data_plane_policing_policy  = try("${ip.egress_data_plane_policing_policy}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}", "")
            ingress_data_plane_policing_policy = try("${ip.ingress_data_plane_policing_policy}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}", "")
            dhcp_labels = [for label in try(ip.dhcp_labels, []) : {
              dhcp_relay_policy  = try("${label.dhcp_relay_policy}${local.defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix}", "")
              dhcp_option_policy = try("${label.dhcp_option_policy}${local.defaults.apic.tenants.policies.dhcp_option_policies.name_suffix}", "")
              scope              = try(label.scope, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.dhcp_labels.scope)
              }
            ]
            netflow_monitor_policies = [for policy in try(ip.netflow_monitor_policies, []) : {
              name           = policy.name
              ip_filter_type = policy.ip_filter_type
            }]
            interfaces = [for int in try(ip.interfaces, []) : {
              ip                   = try(int.ip, "")
              svi                  = try(int.svi, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.svi)
              autostate            = try(int.autostate, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.autostate)
              floating_svi         = try(int.floating_svi, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.floating_svi)
              vlan                 = try(int.vlan, null)
              description          = try(int.description, "")
              type                 = try(int.port, null) != null ? "access" : try([for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel][0], try(int.node2_id, null) != null ? "vpc" : "pc")
              mac                  = try(int.mac, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mac)
              mtu                  = try(int.mtu, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mtu)
              mode                 = try(int.mode, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.mode)
              node_id              = try(int.node_id, try(int.channel, null) != null ? try([for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == int.channel][0][0], null) : null)
              node2_id             = try(int.node2_id, try(int.channel, null) != null ? try([for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel && pg.type == "vpc"][0], null) : null)
              pod_id               = try(int.pod_id, null)
              module               = try(int.module, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.module)
              port                 = try(int.port, null)
              sub_port             = try(int.sub_port, null)
              channel              = try("${int.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
              ip_a                 = try(int.ip_a, null)
              ip_b                 = try(int.ip_b, null)
              ip_shared            = try(int.ip_shared, null)
              ip_shared_dhcp_relay = try(int.ip_shared_dhcp_relay, null)
              lladdr               = try(int.link_local_address, null)
              scope                = try(int.scope, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.scope)
              multipod_direct      = tenant.name == "infra" ? try(int.multipod_direct, false) : false
              bgp_peers = [for peer in try(int.bgp_peers, []) : {
                ip                               = peer.ip
                remote_as                        = peer.remote_as
                description                      = try(peer.description, "")
                allow_self_as                    = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allow_self_as)
                as_override                      = try(peer.as_override, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_override)
                disable_peer_as_check            = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.disable_peer_as_check)
                next_hop_self                    = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.next_hop_self)
                send_community                   = try(peer.send_community, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_community)
                send_ext_community               = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_ext_community)
                password                         = try(peer.password, null)
                allowed_self_as_count            = try(peer.allowed_self_as_count, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allowed_self_as_count)
                bfd                              = try(peer.bfd, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.bfd)
                disable_connected_check          = try(peer.disable_connected_check, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.disable_connected_check)
                ttl                              = try(peer.ttl, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.ttl)
                weight                           = try(peer.weight, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.weight)
                remove_all_private_as            = try(peer.remove_all_private_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.remove_all_private_as)
                remove_private_as                = try(peer.remove_private_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.remove_private_as)
                replace_private_as_with_local_as = try(peer.replace_private_as_with_local_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.replace_private_as_with_local_as)
                unicast_address_family           = try(peer.unicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.unicast_address_family)
                multicast_address_family         = try(peer.multicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.multicast_address_family)
                admin_state                      = try(peer.admin_state, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.admin_state)
                local_as                         = try(peer.local_as, null)
                as_propagate                     = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_propagate)
                peer_prefix_policy               = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
                export_route_control             = try("${peer.export_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
                import_route_control             = try("${peer.import_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
              }]
              paths = [for path in try(int.paths, []) : {
                physical_domain   = try(path.physical_domain, null)
                vmware_vmm_domain = try(path.vmware_vmm_domain, null)
                elag              = try(path.elag, null)
                floating_ip       = path.floating_ip
                vlan              = try(path.vlan, null)
                forged_transmit   = try(path.forged_transmit, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.forged_transmit, null)
                mac_change        = try(path.mac_change, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.mac_change, null)
                promiscous_mode   = try(path.promiscous_mode, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.promiscous_mode, null)
              }]
              micro_bfd_destination_ip = try(int.micro_bfd.destination_ip, null)
              micro_bfd_start_timer    = try(int.micro_bfd.start_timer, null)
            }]
          }
        ]
      ]
    ]
  ])
}

module "aci_l3out_interface_profile_manual" {
  source = "./modules/terraform-aci-l3out-interface-profile"

  for_each                           = { for ip in local.interface_profiles_manual : ip.key => ip if local.modules.aci_l3out_interface_profile && var.manage_tenants }
  tenant                             = each.value.tenant
  l3out                              = each.value.l3out
  node_profile                       = each.value.node_profile
  name                               = each.value.name
  description                        = each.value.description
  multipod                           = each.value.multipod
  remote_leaf                        = each.value.remote_leaf
  bfd_policy                         = each.value.bfd_policy
  ospf_interface_profile_name        = each.value.ospf_interface_profile_name
  ospf_authentication_key            = each.value.ospf_authentication_key
  ospf_authentication_key_id         = each.value.ospf_authentication_key_id
  ospf_authentication_type           = each.value.ospf_authentication_type
  ospf_interface_policy              = each.value.ospf_interface_policy
  eigrp_interface_profile_name       = each.value.eigrp_interface_profile_name
  eigrp_interface_policy             = each.value.eigrp_interface_policy
  eigrp_keychain_policy              = each.value.eigrp_keychain_policy
  pim_policy                         = each.value.pim_policy
  igmp_interface_policy              = each.value.igmp_interface_policy
  nd_interface_policy                = each.value.nd_interface_policy
  qos_class                          = each.value.qos_class
  custom_qos_policy                  = each.value.custom_qos_policy
  dhcp_labels                        = each.value.dhcp_labels
  netflow_monitor_policies           = each.value.netflow_monitor_policies
  egress_data_plane_policing_policy  = each.value.egress_data_plane_policing_policy
  ingress_data_plane_policing_policy = each.value.ingress_data_plane_policing_policy
  interfaces = [for int in try(each.value.interfaces, []) : {
    ip                       = int.ip
    svi                      = int.svi
    floating_svi             = int.floating_svi
    autostate                = int.autostate
    vlan                     = int.vlan
    description              = int.description
    type                     = int.type
    mac                      = int.mac
    mtu                      = int.mtu
    mode                     = int.mode
    node_id                  = int.node_id
    node2_id                 = int.node2_id == "vpc" ? [for pg in local.leaf_interface_policy_group_mapping : try(pg.node_ids, []) if pg.name == int.channel][0][1] : int.node2_id
    pod_id                   = int.pod_id == null ? try([for node in local.node_policies.nodes : node.pod if node.id == int.node_id][0], local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.pod) : int.pod_id
    module                   = int.module
    port                     = int.port
    sub_port                 = int.sub_port
    channel                  = int.channel
    ip_a                     = int.ip_a
    ip_b                     = int.ip_b
    ip_shared                = int.ip_shared
    ip_shared_dhcp_relay     = int.ip_shared_dhcp_relay
    lladdr                   = int.lladdr
    bgp_peers                = int.bgp_peers
    paths                    = int.paths
    scope                    = int.scope
    multipod_direct          = int.multipod_direct
    micro_bfd_destination_ip = int.micro_bfd_destination_ip
    micro_bfd_start_timer    = int.micro_bfd_start_timer
  }]

  depends_on = [
    module.aci_tenant,
    module.aci_l3out_node_profile_manual,
  ]
}

locals {
  interface_profiles_auto = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : {
        key                                = format("%s/%s", tenant.name, l3out.name)
        tenant                             = tenant.name
        l3out                              = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
        node_profile                       = "${l3out.name}${local.defaults.apic.tenants.l3outs.node_profiles.name_suffix}"
        name                               = "${l3out.name}${local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.name_suffix}"
        multipod                           = try(l3out.multipod, local.defaults.apic.tenants.l3outs.multipod)
        remote_leaf                        = try(l3out.remote_leaf, local.defaults.apic.tenants.l3outs.remote_leaf)
        bfd_policy                         = try("${l3out.bfd_policy}${local.defaults.apic.tenants.policies.bfd_interface_policies.name_suffix}", "")
        ospf_interface_profile_name        = try(l3out.ospf.ospf_interface_profile_name, l3out.name)
        ospf_authentication_key            = try(l3out.ospf.auth_key, "")
        ospf_authentication_key_id         = try(l3out.ospf.auth_key_id, "1")
        ospf_authentication_type           = try(l3out.ospf.auth_type, "none")
        ospf_interface_policy              = try(l3out.ospf.policy, "")
        eigrp_interface_profile_name       = try(l3out.eigrp.interface_profile_name, l3out.name)
        eigrp_interface_policy             = try(l3out.eigrp.interface_policy, "")
        pim_policy                         = try("${l3out.pim_policy}${local.defaults.apic.tenants.policies.pim_policies.name_suffix}", "")
        igmp_interface_policy              = try("${l3out.igmp_interface_policy}${local.defaults.apic.tenants.policies.igmp_interface_policies.name_suffix}", "")
        nd_interface_policy                = try("${l3out.nd_interface_policy}${local.defaults.apic.tenants.policies.nd_interface_policies.name_suffix}", "")
        qos_class                          = try(l3out.qos_class, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.qos_class)
        custom_qos_policy                  = try("${l3out.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
        egress_data_plane_policing_policy  = try("${l3out.egress_data_plane_policing_policy}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}", "")
        ingress_data_plane_policing_policy = try("${l3out.ingress_data_plane_policing_policy}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}", "")
        dhcp_labels = [for label in try(l3out.dhcp_labels, []) : {
          dhcp_relay_policy  = try("${label.dhcp_relay_policy}${local.defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix}", "")
          dhcp_option_policy = try("${label.dhcp_option_policy}${local.defaults.apic.tenants.policies.dhcp_option_policies.name_suffix}", "")
          scope              = try(label.scope, local.defaults.apic.tenants.l3outs.dhcp_labels.scope)
          }
        ]
        netflow_monitor_policies = [for policy in try(l3out.netflow_monitor_policies, []) : {
          name           = policy.name
          ip_filter_type = policy.ip_filter_type
        }]
        interfaces = flatten([for node in try(l3out.nodes, []) : [
          for int in try(node.interfaces, []) : {
            ip                   = try(int.ip, "")
            svi                  = try(int.svi, local.defaults.apic.tenants.l3outs.nodes.interfaces.svi)
            autostate            = try(int.autostate, local.defaults.apic.tenants.l3outs.nodes.interfaces.autostate)
            floating_svi         = try(int.floating_svi, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.floating_svi)
            vlan                 = try(int.vlan, null)
            description          = try(int.description, "")
            type                 = try(int.port, null) != null ? "access" : try([for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel][0], try(int.node2_id, null) != null ? "vpc" : "pc")
            mac                  = try(int.mac, local.defaults.apic.tenants.l3outs.nodes.interfaces.mac)
            mtu                  = try(int.mtu, local.defaults.apic.tenants.l3outs.nodes.interfaces.mtu)
            mode                 = try(int.mode, local.defaults.apic.tenants.l3outs.nodes.interfaces.mode)
            node_id              = try(node.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == int.channel][0][0], null)
            node2_id             = try(int.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel && pg.type == "vpc"][0], null)
            pod_id               = try(node.pod_id, [for node_ in local.node_policies.nodes : node_.pod if node_.id == node.node_id][0], local.defaults.apic.tenants.l3outs.nodes.interfaces.pod)
            module               = try(int.module, local.defaults.apic.tenants.l3outs.nodes.interfaces.module)
            port                 = try(int.port, null)
            sub_port             = try(int.sub_port, null)
            channel              = try("${int.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
            ip_a                 = try(int.ip_a, null)
            ip_b                 = try(int.ip_b, null)
            ip_shared            = try(int.ip_shared, null)
            ip_shared_dhcp_relay = try(int.ip_shared_dhcp_relay, null)
            lladdr               = try(int.link_local_address, null)
            scope                = try(int.scope, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.scope)
            multipod_direct      = tenant.name == "infra" ? try(int.multipod_direct, false) : false
            bgp_peers = [for peer in try(int.bgp_peers, []) : {
              ip                               = peer.ip
              remote_as                        = peer.remote_as
              description                      = try(peer.description, "")
              allow_self_as                    = try(peer.allow_self_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allow_self_as)
              as_override                      = try(peer.as_override, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_override)
              disable_peer_as_check            = try(peer.disable_peer_as_check, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.disable_peer_as_check)
              next_hop_self                    = try(peer.next_hop_self, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.next_hop_self)
              send_community                   = try(peer.send_community, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_community)
              send_ext_community               = try(peer.send_ext_community, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_ext_community)
              password                         = try(peer.password, null)
              allowed_self_as_count            = try(peer.allowed_self_as_count, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allowed_self_as_count)
              bfd                              = try(peer.bfd, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.bfd)
              disable_connected_check          = try(peer.disable_connected_check, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.disable_connected_check)
              ttl                              = try(peer.ttl, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.ttl)
              weight                           = try(peer.weight, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.weight)
              remove_all_private_as            = try(peer.remove_all_private_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.remove_all_private_as)
              remove_private_as                = try(peer.remove_private_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.remove_private_as)
              replace_private_as_with_local_as = try(peer.replace_private_as_with_local_as, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.replace_private_as_with_local_as)
              unicast_address_family           = try(peer.unicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.unicast_address_family)
              multicast_address_family         = try(peer.multicast_address_family, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.multicast_address_family)
              admin_state                      = try(peer.admin_state, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.admin_state)
              local_as                         = try(peer.local_as, null)
              as_propagate                     = try(peer.as_propagate, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.as_propagate)
              peer_prefix_policy               = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
              export_route_control             = try("${peer.export_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
              import_route_control             = try("${peer.import_route_control}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}", null)
            }]
            paths = [for path in try(int.paths, []) : {
              physical_domain   = try(path.physical_domain, null)
              vmware_vmm_domain = try(path.vmware_vmm_domain, null)
              elag              = try(path.elag, null)
              floating_ip       = path.floating_ip
              vlan              = try(path.vlan, null)
              forged_transmit   = try(path.forged_transmit, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.forged_transmit, null)
              mac_change        = try(path.mac_change, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.mac_change, null)
              promiscous_mode   = try(path.promiscous_mode, local.defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.paths.promiscous_mode, null)
            }]
            micro_bfd_destination_ip = try(int.micro_bfd.destination_ip, null)
            micro_bfd_start_timer    = try(int.micro_bfd.start_timer, null)
          }
        ]])
      } if length(try(l3out.nodes, [])) != 0
    ]
  ])
}

module "aci_l3out_interface_profile_auto" {
  source = "./modules/terraform-aci-l3out-interface-profile"

  for_each                           = { for ip in local.interface_profiles_auto : ip.key => ip if local.modules.aci_l3out_interface_profile && var.manage_tenants }
  tenant                             = each.value.tenant
  l3out                              = each.value.l3out
  node_profile                       = each.value.node_profile
  name                               = each.value.name
  multipod                           = each.value.multipod
  remote_leaf                        = each.value.remote_leaf
  bfd_policy                         = each.value.bfd_policy
  ospf_interface_profile_name        = each.value.ospf_interface_profile_name
  ospf_authentication_key            = each.value.ospf_authentication_key
  ospf_authentication_key_id         = each.value.ospf_authentication_key_id
  ospf_authentication_type           = each.value.ospf_authentication_type
  ospf_interface_policy              = each.value.ospf_interface_policy
  eigrp_interface_profile_name       = each.value.eigrp_interface_profile_name
  eigrp_interface_policy             = each.value.eigrp_interface_policy
  pim_policy                         = each.value.pim_policy
  igmp_interface_policy              = each.value.igmp_interface_policy
  nd_interface_policy                = each.value.nd_interface_policy
  qos_class                          = each.value.qos_class
  custom_qos_policy                  = each.value.custom_qos_policy
  dhcp_labels                        = each.value.dhcp_labels
  netflow_monitor_policies           = each.value.netflow_monitor_policies
  egress_data_plane_policing_policy  = each.value.egress_data_plane_policing_policy
  ingress_data_plane_policing_policy = each.value.ingress_data_plane_policing_policy
  interfaces = [for int in try(each.value.interfaces, []) : {
    ip                       = int.ip
    svi                      = int.svi
    autostate                = int.autostate
    floating_svi             = int.floating_svi
    vlan                     = int.vlan
    description              = int.description
    type                     = int.type
    mac                      = int.mac
    mtu                      = int.mtu
    mode                     = int.mode
    node_id                  = int.node_id
    node2_id                 = int.node2_id == "vpc" ? [for pg in local.leaf_interface_policy_group_mapping : try(pg.node_ids, []) if pg.name == int.channel][0][1] : int.node2_id
    pod_id                   = int.pod_id
    module                   = int.module
    port                     = int.port
    sub_port                 = int.sub_port
    channel                  = int.channel
    ip_a                     = int.ip_a
    ip_b                     = int.ip_b
    ip_shared                = int.ip_shared
    ip_shared_dhcp_relay     = int.ip_shared_dhcp_relay
    lladdr                   = int.lladdr
    bgp_peers                = int.bgp_peers
    paths                    = int.paths
    scope                    = int.scope
    multipod_direct          = int.multipod_direct
    micro_bfd_destination_ip = int.micro_bfd_destination_ip
    micro_bfd_start_timer    = int.micro_bfd_start_timer
  }]

  depends_on = [
    module.aci_tenant,
    module.aci_l3out_node_profile_auto,
  ]
}

locals {
  external_endpoint_groups = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.l3outs, []) : [
        for epg in try(l3out.external_endpoint_groups, []) : {
          key                         = format("%s/%s/%s", tenant.name, l3out.name, epg.name)
          tenant                      = tenant.name
          l3out                       = "${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}"
          name                        = "${epg.name}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}"
          annotation                  = try(epg.ndo_managed, local.defaults.apic.tenants.l3outs.external_endpoint_groups.ndo_managed) ? "orchestrator:msc-shadow:no" : null
          alias                       = try(epg.alias, "")
          description                 = try(epg.description, "")
          preferred_group             = try(epg.preferred_group, local.defaults.apic.tenants.l3outs.external_endpoint_groups.preferred_group)
          qos_class                   = try(epg.qos_class, local.defaults.apic.tenants.l3outs.external_endpoint_groups.qos_class)
          target_dscp                 = try(epg.target_dscp, local.defaults.apic.tenants.l3outs.external_endpoint_groups.target_dscp)
          contract_consumers          = try([for contract in epg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_providers          = try([for contract in epg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_imported_consumers = try([for contract in epg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
          route_control_profiles = [for rcp in try(epg.route_control_profiles, []) : {
            name      = rcp.name
            direction = try(rcp.direction, local.defaults.apic.tenants.l3outs.external_endpoint_groups.route_control_profiles.direction)
          }]
          subnets = [for subnet in try(epg.subnets, []) : {
            name                            = try(subnet.name, "")
            annotation                      = try(subnet.ndo_managed, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.ndo_managed) ? "orchestrator:msc" : null
            prefix                          = subnet.prefix
            description                     = try(subnet.description, "")
            import_route_control            = try(subnet.import_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.import_route_control)
            export_route_control            = try(subnet.export_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.export_route_control)
            shared_route_control            = try(subnet.shared_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.shared_route_control)
            import_security                 = try(subnet.import_security, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.import_security)
            shared_security                 = try(subnet.shared_security, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.shared_security)
            aggregate_import_route_control  = try(subnet.aggregate_import_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.aggregate_import_route_control)
            aggregate_export_route_control  = try(subnet.aggregate_export_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.aggregate_export_route_control)
            aggregate_shared_route_control  = try(subnet.aggregate_shared_route_control, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.aggregate_shared_route_control)
            bgp_route_summarization         = try(subnet.bgp_route_summarization, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.bgp_route_summarization)
            bgp_route_summarization_policy  = try(subnet.bgp_route_summarization_policy, "")
            ospf_route_summarization        = try(subnet.ospf_route_summarization, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.ospf_route_summarization)
            ospf_route_summarization_policy = try(subnet.ospf_route_summarization_policy, "")
            eigrp_route_summarization       = try(subnet.eigrp_route_summarization, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.eigrp_route_summarization)
            route_control_profiles = [for rcp in try(subnet.route_control_profiles, []) : {
              name      = rcp.name
              direction = try(rcp.direction, local.defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.route_control_profiles.direction)
            }]
          }]
        }
      ]
    ]
  ])
}

module "aci_external_endpoint_group" {
  source = "./modules/terraform-aci-external-endpoint-group"

  for_each                    = { for epg in local.external_endpoint_groups : epg.key => epg if local.modules.aci_external_endpoint_group && var.manage_tenants }
  tenant                      = each.value.tenant
  l3out                       = each.value.l3out
  name                        = each.value.name
  annotation                  = each.value.annotation
  alias                       = each.value.alias
  description                 = each.value.description
  preferred_group             = each.value.preferred_group
  qos_class                   = each.value.qos_class
  target_dscp                 = each.value.target_dscp
  contract_consumers          = each.value.contract_consumers
  contract_providers          = each.value.contract_providers
  contract_imported_consumers = each.value.contract_imported_consumers
  route_control_profiles      = each.value.route_control_profiles
  subnets                     = each.value.subnets

  depends_on = [
    module.aci_tenant,
    module.aci_l3out,
    module.aci_contract,
    module.aci_imported_contract,
  ]
}

locals {
  filters = flatten([
    for tenant in local.tenants : [
      for filter in try(tenant.filters, []) : {
        key         = format("%s/%s", tenant.name, filter.name)
        tenant      = tenant.name
        name        = "${filter.name}${local.defaults.apic.tenants.filters.name_suffix}"
        alias       = try(filter.alias, "")
        description = try(filter.description, "")
        entries = [for entry in try(filter.entries, []) : {
          name                  = "${entry.name}${local.defaults.apic.tenants.filters.entries.name_suffix}"
          alias                 = try(entry.alias, "")
          description           = try(entry.description, "")
          ethertype             = try(entry.ethertype, local.defaults.apic.tenants.filters.entries.ethertype)
          protocol              = try(entry.protocol, local.defaults.apic.tenants.filters.entries.protocol)
          source_from_port      = try(entry.source_from_port, local.defaults.apic.tenants.filters.entries.source_from_port)
          source_to_port        = try(entry.source_to_port, entry.source_from_port, local.defaults.apic.tenants.filters.entries.source_from_port)
          destination_from_port = try(entry.destination_from_port, local.defaults.apic.tenants.filters.entries.destination_from_port)
          destination_to_port   = try(entry.destination_to_port, entry.destination_from_port, local.defaults.apic.tenants.filters.entries.destination_from_port)
          stateful              = try(entry.stateful, local.defaults.apic.tenants.filters.entries.stateful)
          match_only_fragments  = try(entry.match_only_fragments, local.defaults.apic.tenants.filters.entries.match_only_fragments)
        }]
      }
    ]
  ])
}

locals {
  sr_mpls_l3outs = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.sr_mpls_l3outs, []) : {
        key                  = format("%s/%s", tenant.name, l3out.name)
        tenant               = tenant.name
        name                 = "${l3out.name}${local.defaults.apic.tenants.sr_mpls_l3outs.name_suffix}"
        alias                = try(l3out.alias, "")
        description          = try(l3out.description, "")
        domain               = try("${l3out.domain}${local.defaults.apic.access_policies.routed_domains.name_suffix}", "")
        vrf                  = tenant.name == "infra" ? "overlay-1" : try("${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", "")
        transport_data_plane = try(l3out.transport_data_plane, local.defaults.apic.tenants.sr_mpls_l3outs.transport_data_plane)
        sr_mpls              = true
        sr_mpls_infra_l3outs = [for infra_l3out in try(l3out.sr_mpls_infra_l3outs, []) : {
          name                     = infra_l3out.name
          outbound_route_map       = try(infra_l3out.outbound_route_map, "")
          inbound_route_map        = try(infra_l3out.inbound_route_map, "")
          external_endpoint_groups = [for eepg in try(infra_l3out.external_endpoint_groups, []) : eepg]
        }]
      }
    ]
  ])
}

module "aci_sr_mpls_l3out" {
  source = "./modules/terraform-aci-l3out"

  for_each             = { for l3out in local.sr_mpls_l3outs : l3out.key => l3out if try(local.modules.aci_sr_mpls_l3out, true) && var.manage_tenants }
  tenant               = each.value.tenant
  name                 = each.value.name
  alias                = each.value.alias
  description          = each.value.description
  routed_domain        = each.value.domain
  vrf                  = each.value.vrf
  sr_mpls              = each.value.sr_mpls
  sr_mpls_infra_l3outs = each.value.sr_mpls_infra_l3outs

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  sr_mpls_node_profiles_manual = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.sr_mpls_l3outs, []) : [
        for np in try(l3out.node_profiles, []) : {
          key                      = format("%s/%s/%s", tenant.name, l3out.name, np.name)
          tenant                   = tenant.name
          l3out                    = "${l3out.name}${local.defaults.apic.tenants.sr_mpls_l3outs.name_suffix}"
          name                     = "${np.name}${local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.name_suffix}"
          sr_mpls                  = true
          mpls_custom_qos_policy   = try(np.mpls_custom_qos_policy, "")
          bfd_multihop_node_policy = try(np.bfd_multihop_node_policy, "")
          nodes = [for node in try(np.nodes, []) : {
            node_id                 = node.node_id
            pod_id                  = try(node.pod_id, [for node_ in local.node_policies.nodes : node_.pod if node_.id == node.node_id][0], local.defaults.apic.tenants.l3outs.node_profiles.nodes.pod)
            router_id               = try(node.router_id, null)
            router_id_as_loopback   = false
            loopbacks               = [node.bgp_evpn_loopback]
            mpls_transport_loopback = node.mpls_transport_loopback
            segment_id              = node.segment_id
          }]
          bgp_infra_peers = [for peer in try(np.evpn_connectivity, []) : {
            ip                    = peer.ip
            remote_as             = peer.remote_as
            description           = try(peer.description, "")
            allow_self_as         = try(peer.allow_self_as, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.allow_self_as)
            disable_peer_as_check = try(peer.disable_peer_as_check, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.disable_peer_as_check)
            password              = try(peer.password, null)
            bfd                   = try(peer.bfd, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.bfd)
            ttl                   = try(peer.ttl, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.ttl)
            admin_state           = try(peer.admin_state, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.admin_state)
            local_as              = try(peer.local_as, null)
            as_propagate          = try(peer.as_propagate, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.evpn_connectivity.as_propagate)
            peer_prefix_policy    = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
            peer_type             = "sr-mpls"
            send_community        = true
            send_ext_community    = true
          }]
        }
      ]
    ]
  ])
}

module "aci_sr_mpls_l3out_node_profile_manual" {
  source = "./modules/terraform-aci-l3out-node-profile"

  for_each                 = { for np in local.sr_mpls_node_profiles_manual : np.key => np if try(local.modules.aci_sr_mpls_l3out_node_profile, true) && var.manage_tenants }
  tenant                   = each.value.tenant
  l3out                    = each.value.l3out
  name                     = each.value.name
  sr_mpls                  = each.value.sr_mpls
  mpls_custom_qos_policy   = each.value.mpls_custom_qos_policy
  bfd_multihop_node_policy = each.value.bfd_multihop_node_policy
  nodes                    = each.value.nodes
  bgp_infra_peers          = each.value.bgp_infra_peers

  depends_on = [
    module.aci_tenant,
    module.aci_sr_mpls_l3out,
  ]
}

locals {
  sr_mpls_interface_profiles_manual = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.sr_mpls_l3outs, []) : [
        for np in try(l3out.node_profiles, []) : [
          for ip in try(np.interface_profiles, []) : {
            key                  = format("%s/%s/%s/%s", tenant.name, l3out.name, np.name, ip.name)
            tenant               = tenant.name
            l3out                = "${l3out.name}${local.defaults.apic.tenants.sr_mpls_l3outs.name_suffix}"
            node_profile         = "${np.name}${local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.name_suffix}"
            sr_mpls              = true
            transport_data_plane = l3out.transport_data_plane
            name                 = "${ip.name}${local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.name_suffix}"
            bfd_policy           = try("${ip.bfd_policy}${local.defaults.apic.tenants.policies.bfd_interface_policies.name_suffix}", "")
            interfaces = [for int in try(ip.interfaces, []) : {
              ip_a        = try(int.ip, "")
              vlan        = try(int.vlan, null)
              description = try(int.description, "")
              type        = try(int.port, null) != null ? "access" : try([for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel][0], "pc")
              mac         = try(int.mac, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.mac)
              mtu         = try(int.mtu, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.mtu)
              node_id     = try(int.node_id, try(int.channel, null) != null ? try([for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == int.channel][0][0], null) : null)
              pod_id      = try(int.pod_id, null)
              module      = try(int.module, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.module)
              port        = try(int.port, null)
              channel     = try("${int.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
              ip          = try(int.ip, null)
              bgp_peers = [for peer in try(int.bgp_peers, []) : {
                ip                     = peer.ip
                remote_as              = peer.remote_as
                description            = try(peer.description, "")
                allow_self_as          = try(peer.allow_self_as, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.allow_self_as)
                send_community         = try(peer.send_community, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_community)
                send_ext_community     = try(peer.send_ext_community, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.send_ext_community)
                password               = try(peer.password, null)
                bfd                    = try(peer.bfd, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.bfd)
                unicast_address_family = try(peer.unicast_address_family, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.unicast_address_family)
                admin_state            = try(peer.admin_state, local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.bgp_peers.admin_state)
                local_as               = try(peer.local_as, null)
                peer_prefix_policy     = try("${peer.peer_prefix_policy}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}", null)
              }]
            }]
          }
        ]
      ]
    ]
  ])
}

module "aci_sr_mpls_l3out_interface_profile_manual" {
  source = "./modules/terraform-aci-l3out-interface-profile"

  for_each             = { for ip in local.sr_mpls_interface_profiles_manual : ip.key => ip if try(local.modules.aci_sr_mpls_l3out_interface_profile, true) && var.manage_tenants }
  tenant               = each.value.tenant
  l3out                = each.value.l3out
  sr_mpls              = each.value.sr_mpls
  node_profile         = each.value.node_profile
  name                 = each.value.name
  bfd_policy           = each.value.bfd_policy
  transport_data_plane = each.value.transport_data_plane
  interfaces = [for int in try(each.value.interfaces, []) : {
    ip_a        = int.ip_a
    vlan        = int.vlan
    description = int.description
    type        = int.type
    mac         = int.mac
    mtu         = int.mtu
    node_id     = int.node_id
    pod_id      = try(int.pod_id, [for node in local.node_policies.nodes : node.pod if node.id == int.node_id][0], local.defaults.apic.tenants.sr_mpls_l3outs.node_profiles.interface_profiles.interfaces.pod)
    module      = int.module
    port        = int.port
    channel     = int.channel
    ip          = int.ip
    bgp_peers   = int.bgp_peers
  }]

  depends_on = [
    module.aci_tenant,
    module.aci_sr_mpls_l3out_node_profile_manual,
  ]
}

locals {
  sr_mpls_external_endpoint_groups = flatten([
    for tenant in local.tenants : [
      for l3out in try(tenant.sr_mpls_l3outs, []) : [
        for epg in try(l3out.external_endpoint_groups, []) : {
          key                         = format("%s/%s/%s", tenant.name, l3out.name, epg.name)
          tenant                      = tenant.name
          l3out                       = "${l3out.name}${local.defaults.apic.tenants.sr_mpls_l3outs.name_suffix}"
          name                        = "${epg.name}${local.defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.name_suffix}"
          alias                       = try(epg.alias, "")
          description                 = try(epg.description, "")
          preferred_group             = try(epg.preferred_group, local.defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.preferred_group)
          contract_consumers          = try([for contract in epg.contracts.consumers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_providers          = try([for contract in epg.contracts.providers : "${contract}${local.defaults.apic.tenants.contracts.name_suffix}"], [])
          contract_imported_consumers = try([for contract in epg.contracts.imported_consumers : "${contract}${local.defaults.apic.tenants.imported_contracts.name_suffix}"], [])
          subnets = [for subnet in try(epg.subnets, []) : {
            name                           = try(subnet.name, "")
            prefix                         = subnet.prefix
            shared_route_control           = try(subnet.route_leaking, local.defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.route_leaking)
            shared_security                = try(subnet.security, local.defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.security)
            aggregate_shared_route_control = try(subnet.aggregate_shared_route_control, local.defaults.apic.tenants.sr_mpls_l3outs.external_endpoint_groups.subnets.aggregate_shared_route_control)
          }]
        }
      ]
    ]
  ])
}

module "aci_sr_mpls_external_endpoint_group" {
  source = "./modules/terraform-aci-external-endpoint-group"

  for_each                    = { for epg in local.sr_mpls_external_endpoint_groups : epg.key => epg if try(local.modules.sr_mpls_aci_external_endpoint_group, true) && var.manage_tenants }
  tenant                      = each.value.tenant
  l3out                       = each.value.l3out
  name                        = each.value.name
  alias                       = each.value.alias
  description                 = each.value.description
  preferred_group             = each.value.preferred_group
  contract_consumers          = each.value.contract_consumers
  contract_providers          = each.value.contract_providers
  contract_imported_consumers = each.value.contract_imported_consumers
  subnets                     = each.value.subnets

  depends_on = [
    module.aci_tenant,
    module.aci_sr_mpls_l3out,
    module.aci_contract,
    module.aci_imported_contract,
  ]
}

module "aci_filter" {
  source = "./modules/terraform-aci-filter"

  for_each    = { for filter in local.filters : filter.key => filter if local.modules.aci_filter && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  alias       = each.value.alias
  description = each.value.description
  entries     = each.value.entries

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  contracts = flatten([
    for tenant in local.tenants : [
      for contract in try(tenant.contracts, []) : {
        key         = format("%s/%s", tenant.name, contract.name)
        tenant      = tenant.name
        name        = "${contract.name}${local.defaults.apic.tenants.contracts.name_suffix}"
        alias       = try(contract.alias, "")
        description = try(contract.description, "")
        scope       = try(contract.scope, local.defaults.apic.tenants.contracts.scope)
        qos_class   = try(contract.qos_class, local.defaults.apic.tenants.contracts.qos_class)
        target_dscp = try(contract.target_dscp, local.defaults.apic.tenants.contracts.target_dscp)
        subjects = [for subject in try(contract.subjects, []) : {
          name                 = "${subject.name}${local.defaults.apic.tenants.contracts.subjects.name_suffix}"
          alias                = try(subject.alias, "")
          description          = try(subject.description, "")
          reverse_filter_ports = try(subject.reverse_filter_ports, local.defaults.apic.tenants.contracts.subjects.reverse_filter_ports)
          service_graph        = try("${subject.service_graph}${local.defaults.apic.tenants.services.service_graph_templates.name_suffix}", null)
          qos_class            = try(subject.qos_class, local.defaults.apic.tenants.contracts.subjects.qos_class)
          target_dscp          = try(subject.target_dscp, local.defaults.apic.tenants.contracts.subjects.target_dscp)
          filters = [for filter in try(subject.filters, []) : {
            filter   = "${filter.filter}${local.defaults.apic.tenants.filters.name_suffix}"
            action   = try(filter.action, local.defaults.apic.tenants.contracts.subjects.filters.action)
            priority = try(filter.priority, local.defaults.apic.tenants.contracts.subjects.filters.priority)
            log      = try(filter.log, local.defaults.apic.tenants.contracts.subjects.filters.log)
            no_stats = try(filter.no_stats, local.defaults.apic.tenants.contracts.subjects.filters.no_stats)
          }]
          consumer_to_provider_service_graph = try("${subject.consumer_to_provider.service_graph}${local.defaults.apic.tenants.services.service_graph_templates.name_suffix}", null)
          consumer_to_provider_qos_class     = try(subject.consumer_to_provider.qos_class, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.qos_class)
          consumer_to_provider_target_dscp   = try(subject.consumer_to_provider.target_dscp, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.target_dscp)
          consumer_to_provider_filters = [for filter in try(subject.consumer_to_provider.filters, []) : {
            filter   = "${filter.filter}${local.defaults.apic.tenants.filters.name_suffix}"
            action   = try(filter.action, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.filters.action)
            priority = try(filter.priority, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.filters.priority)
            log      = try(filter.log, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.filters.log)
            no_stats = try(filter.no_stats, local.defaults.apic.tenants.contracts.subjects.consumer_to_provider.filters.no_stats)
          }]
          provider_to_consumer_service_graph = try("${subject.provider_to_consumer.service_graph}${local.defaults.apic.tenants.services.service_graph_templates.name_suffix}", null)
          provider_to_consumer_qos_class     = try(subject.provider_to_consumer.qos_class, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.qos_class)
          provider_to_consumer_target_dscp   = try(subject.provider_to_consumer.target_dscp, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.target_dscp)
          provider_to_consumer_filters = [for filter in try(subject.provider_to_consumer.filters, []) : {
            filter   = "${filter.filter}${local.defaults.apic.tenants.filters.name_suffix}"
            action   = try(filter.action, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.filters.action)
            priority = try(filter.priority, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.filters.priority)
            log      = try(filter.log, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.filters.log)
            no_stats = try(filter.no_stats, local.defaults.apic.tenants.contracts.subjects.provider_to_consumer.filters.no_stats)
          }]
        }]
      }
    ]
  ])
}

module "aci_contract" {
  source = "./modules/terraform-aci-contract"

  for_each    = { for contract in local.contracts : contract.key => contract if local.modules.aci_contract && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  alias       = each.value.alias
  description = each.value.description
  scope       = each.value.scope
  qos_class   = each.value.qos_class
  target_dscp = each.value.target_dscp
  subjects    = each.value.subjects

  depends_on = [
    module.aci_tenant,
    module.aci_filter,
  ]
}

locals {
  oob_contracts = flatten([
    for tenant in local.tenants : [
      for contract in try(tenant.oob_contracts, []) : {
        key         = format("%s/%s", tenant.name, contract.name)
        name        = "${contract.name}${local.defaults.apic.tenants.oob_contracts.name_suffix}"
        alias       = try(contract.alias, "")
        description = try(contract.description, "")
        scope       = try(contract.scope, local.defaults.apic.tenants.oob_contracts.scope)
        subjects = [for subject in try(contract.subjects, []) : {
          name        = "${subject.name}${local.defaults.apic.tenants.oob_contracts.subjects.name_suffix}"
          alias       = try(subject.alias, "")
          description = try(subject.description, "")
          filters = [for filter in try(subject.filters, []) : {
            filter = "${filter.filter}${local.defaults.apic.tenants.filters.name_suffix}"
          }]
        }]
      }
    ] if tenant.name == "mgmt"
  ])
}

module "aci_oob_contract" {
  source = "./modules/terraform-aci-oob-contract"

  for_each    = { for contract in local.oob_contracts : contract.key => contract if local.modules.aci_oob_contract && var.manage_tenants }
  name        = each.value.name
  alias       = each.value.alias
  description = each.value.description
  scope       = each.value.scope
  subjects    = each.value.subjects

  depends_on = [
    module.aci_tenant,
    module.aci_filter,
  ]
}

locals {
  imported_contracts = flatten([
    for tenant in local.tenants : [
      for contract in try(tenant.imported_contracts, []) : {
        key             = format("%s/%s", tenant.name, contract.name)
        tenant          = tenant.name
        name            = "${contract.name}${local.defaults.apic.tenants.imported_contracts.name_suffix}"
        source_contract = "${contract.contract}${local.defaults.apic.tenants.contracts.name_suffix}"
        source_tenant   = contract.tenant
      }
    ]
  ])
}

module "aci_imported_contract" {
  source = "./modules/terraform-aci-imported-contract"

  for_each        = { for contract in local.imported_contracts : contract.key => contract if local.modules.aci_imported_contract && var.manage_tenants }
  tenant          = each.value.tenant
  name            = each.value.name
  source_contract = each.value.source_contract
  source_tenant   = each.value.source_tenant

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  ospf_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.ospf_interface_policies, []) : {
        key                     = format("%s/%s", tenant.name, policy.name)
        tenant                  = tenant.name
        name                    = "${policy.name}${local.defaults.apic.tenants.policies.ospf_interface_policies.name_suffix}"
        description             = try(policy.description, "")
        cost                    = try(policy.cost, local.defaults.apic.tenants.policies.ospf_interface_policies.cost)
        dead_interval           = try(policy.dead_interval, local.defaults.apic.tenants.policies.ospf_interface_policies.dead_interval)
        hello_interval          = try(policy.hello_interval, local.defaults.apic.tenants.policies.ospf_interface_policies.hello_interval)
        network_type            = try(policy.network_type, local.defaults.apic.tenants.policies.ospf_interface_policies.network_type)
        priority                = try(policy.priority, local.defaults.apic.tenants.policies.ospf_interface_policies.priority)
        lsa_retransmit_interval = try(policy.lsa_retransmit_interval, local.defaults.apic.tenants.policies.ospf_interface_policies.lsa_retransmit_interval)
        lsa_transmit_delay      = try(policy.lsa_transmit_delay, local.defaults.apic.tenants.policies.ospf_interface_policies.lsa_transmit_delay)
        passive_interface       = try(policy.passive_interface, local.defaults.apic.tenants.policies.ospf_interface_policies.passive_interface)
        mtu_ignore              = try(policy.mtu_ignore, local.defaults.apic.tenants.policies.ospf_interface_policies.mtu_ignore)
        advertise_subnet        = try(policy.advertise_subnet, local.defaults.apic.tenants.policies.ospf_interface_policies.advertise_subnet)
        bfd                     = try(policy.bfd, local.defaults.apic.tenants.policies.ospf_interface_policies.bfd)
      }
    ]
  ])
}

module "aci_ospf_interface_policy" {
  source = "./modules/terraform-aci-ospf-interface-policy"

  for_each                = { for policy in local.ospf_interface_policies : policy.key => policy if local.modules.aci_ospf_interface_policy && var.manage_tenants }
  tenant                  = each.value.tenant
  name                    = each.value.name
  description             = each.value.description
  cost                    = each.value.cost
  dead_interval           = each.value.dead_interval
  hello_interval          = each.value.hello_interval
  network_type            = each.value.network_type
  priority                = each.value.priority
  lsa_retransmit_interval = each.value.lsa_retransmit_interval
  lsa_transmit_delay      = each.value.lsa_transmit_delay
  passive_interface       = each.value.passive_interface
  mtu_ignore              = each.value.mtu_ignore
  advertise_subnet        = each.value.advertise_subnet
  bfd                     = each.value.bfd

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  ospf_timer_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.ospf_timer_policies, []) : {
        key                       = format("%s/%s", tenant.name, policy.name)
        tenant                    = tenant.name
        name                      = "${policy.name}${local.defaults.apic.tenants.policies.ospf_timer_policies.name_suffix}"
        description               = try(policy.description, "")
        reference_bandwidth       = try(policy.reference_bandwidth, local.defaults.apic.tenants.policies.ospf_timer_policies.reference_bandwidth)
        distance                  = try(policy.distance, local.defaults.apic.tenants.policies.ospf_timer_policies.distance)
        max_ecmp                  = try(policy.max_ecmp, local.defaults.apic.tenants.policies.ospf_timer_policies.max_ecmp)
        spf_init_interval         = try(policy.spf_init_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.spf_init_interval)
        spf_hold_interval         = try(policy.spf_hold_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.spf_hold_interval)
        spf_max_interval          = try(policy.spf_max_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.spf_max_interval)
        max_lsa_reset_interval    = try(policy.max_lsa_reset_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_reset_interval)
        max_lsa_sleep_count       = try(policy.max_lsa_sleep_count, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_count)
        max_lsa_sleep_interval    = try(policy.max_lsa_sleep_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_sleep_interval)
        lsa_arrival_interval      = try(policy.lsa_arrival_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.lsa_arrival_interval)
        lsa_group_pacing_interval = try(policy.lsa_group_pacing_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.lsa_group_pacing_interval)
        lsa_hold_interval         = try(policy.lsa_hold_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.lsa_hold_interval)
        lsa_start_interval        = try(policy.lsa_start_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.lsa_start_interval)
        lsa_max_interval          = try(policy.lsa_max_interval, local.defaults.apic.tenants.policies.ospf_timer_policies.lsa_max_interval)
        max_lsa_num               = try(policy.max_lsa_num, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_num)
        max_lsa_threshold         = try(policy.max_lsa_threshold, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_threshold)
        max_lsa_action            = try(policy.max_lsa_action, local.defaults.apic.tenants.policies.ospf_timer_policies.max_lsa_action)
        graceful_restart          = try(policy.graceful_restart, local.defaults.apic.tenants.policies.ospf_timer_policies.graceful_restart)
        router_id_lookup          = try(policy.router_id_lookup, local.defaults.apic.tenants.policies.ospf_timer_policies.router_id_lookup)
        prefix_suppression        = try(policy.prefix_suppression, local.defaults.apic.tenants.policies.ospf_timer_policies.prefix_suppression)
      }
    ]
  ])
}

module "aci_ospf_timer_policy" {
  source = "./modules/terraform-aci-ospf-timer-policy"

  for_each                  = { for policy in local.ospf_timer_policies : policy.key => policy if local.modules.aci_ospf_timer_policy && var.manage_tenants }
  tenant                    = each.value.tenant
  name                      = each.value.name
  description               = each.value.description
  reference_bandwidth       = each.value.reference_bandwidth
  distance                  = each.value.distance
  max_ecmp                  = each.value.max_ecmp
  spf_init_interval         = each.value.spf_init_interval
  spf_hold_interval         = each.value.spf_hold_interval
  spf_max_interval          = each.value.spf_max_interval
  max_lsa_reset_interval    = each.value.max_lsa_reset_interval
  max_lsa_sleep_count       = each.value.max_lsa_sleep_count
  max_lsa_sleep_interval    = each.value.max_lsa_sleep_interval
  lsa_arrival_interval      = each.value.lsa_arrival_interval
  lsa_group_pacing_interval = each.value.lsa_group_pacing_interval
  lsa_hold_interval         = each.value.lsa_hold_interval
  lsa_start_interval        = each.value.lsa_start_interval
  lsa_max_interval          = each.value.lsa_max_interval
  max_lsa_num               = each.value.max_lsa_num
  max_lsa_threshold         = each.value.max_lsa_threshold
  max_lsa_action            = each.value.max_lsa_action
  graceful_restart          = each.value.graceful_restart
  router_id_lookup          = each.value.router_id_lookup
  prefix_suppression        = each.value.prefix_suppression

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  eigrp_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.eigrp_interface_policies, []) : {
        key               = format("%s/%s", tenant.name, policy.name)
        tenant            = tenant.name
        name              = "${policy.name}${local.defaults.apic.tenants.policies.eigrp_interface_policies.name_suffix}"
        description       = try(policy.description, "")
        hold_interval     = try(policy.hold_interval, local.defaults.apic.tenants.policies.eigrp_interface_policies.hold_interval)
        hello_interval    = try(policy.hello_interval, local.defaults.apic.tenants.policies.eigrp_interface_policies.hello_interval)
        bandwidth         = try(policy.bandwidth, local.defaults.apic.tenants.policies.eigrp_interface_policies.bandwidth)
        delay             = try(policy.delay, local.defaults.apic.tenants.policies.eigrp_interface_policies.delay)
        delay_unit        = try(policy.delay_unit, local.defaults.apic.tenants.policies.eigrp_interface_policies.delay_unit)
        passive_interface = try(policy.passive_interface, local.defaults.apic.tenants.policies.eigrp_interface_policies.passive_interface)
        split_horizon     = try(policy.split_horizon, local.defaults.apic.tenants.policies.eigrp_interface_policies.split_horizon)
        self_nexthop      = try(policy.self_nexthop, local.defaults.apic.tenants.policies.eigrp_interface_policies.self_nexthop)
        bfd               = try(policy.bfd, local.defaults.apic.tenants.policies.eigrp_interface_policies.bfd)
      }
    ]
  ])
}

module "aci_eigrp_interface_policy" {
  source = "./modules/terraform-aci-eigrp-interface-policy"

  for_each          = { for policy in local.eigrp_interface_policies : policy.key => policy if local.modules.aci_eigrp_interface_policy && var.manage_tenants }
  tenant            = each.value.tenant
  name              = each.value.name
  description       = each.value.description
  hold_interval     = each.value.hold_interval
  hello_interval    = each.value.hello_interval
  bandwidth         = each.value.bandwidth
  delay             = each.value.delay
  delay_unit        = each.value.delay_unit
  passive_interface = each.value.passive_interface
  self_nexthop      = each.value.self_nexthop
  split_horizon     = each.value.split_horizon
  bfd               = each.value.bfd

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  ospf_route_summarization_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.ospf_route_summarization_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.ospf_route_summarization_policies.name_suffix}"
        description = try(policy.description, "")
        cost        = try(policy.cost, local.defaults.apic.tenants.policies.ospf_route_summarization_policies.cost)
        inter_area  = try(policy.inter_area, local.defaults.apic.tenants.policies.ospf_route_summarization_policies.inter_area)
      }
    ]
  ])
}

module "aci_ospf_route_summarization_policy" {
  source = "./modules/terraform-aci-ospf-route-summarization-policy"

  for_each    = { for pol in local.ospf_route_summarization_policies : pol.key => pol if local.modules.aci_ospf_route_summarization_policy && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  cost        = each.value.cost
  inter_area  = each.value.inter_area

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bgp_route_summarization_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bgp_route_summarization_policies, []) : {
        key          = format("%s/%s", tenant.name, policy.name)
        tenant       = tenant.name
        name         = "${policy.name}${local.defaults.apic.tenants.policies.bgp_route_summarization_policies.name_suffix}"
        description  = try(policy.description, "")
        as_set       = try(policy.as_set, local.defaults.apic.tenants.policies.bgp_route_summarization_policies.as_set)
        summary_only = try(policy.summary_only, local.defaults.apic.tenants.policies.bgp_route_summarization_policies.summary_only)
        af_mcast     = try(policy.af_mcast, local.defaults.apic.tenants.policies.bgp_route_summarization_policies.af_mcast)
        af_ucast     = try(policy.af_ucast, local.defaults.apic.tenants.policies.bgp_route_summarization_policies.af_ucast)
      }
    ]
  ])
}

module "aci_bgp_route_summarization_policy" {
  source = "./modules/terraform-aci-bgp-route-summarization-policy"

  for_each     = { for pol in local.bgp_route_summarization_policies : pol.key => pol if local.modules.aci_bgp_route_summarization_policy && var.manage_tenants }
  tenant       = each.value.tenant
  name         = each.value.name
  description  = each.value.description
  as_set       = each.value.as_set
  summary_only = each.value.summary_only
  af_mcast     = each.value.af_mcast
  af_ucast     = each.value.af_ucast

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bgp_timer_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bgp_timer_policies, []) : {
        key                     = format("%s/%s", tenant.name, policy.name)
        tenant                  = tenant.name
        name                    = "${policy.name}${local.defaults.apic.tenants.policies.bgp_timer_policies.name_suffix}"
        description             = try(policy.description, "")
        graceful_restart_helper = try(policy.graceful_restart_helper, local.defaults.apic.tenants.policies.bgp_timer_policies.graceful_restart_helper)
        hold_interval           = try(policy.hold_interval, local.defaults.apic.tenants.policies.bgp_timer_policies.hold_interval)
        keepalive_interval      = try(policy.keepalive_interval, local.defaults.apic.tenants.policies.bgp_timer_policies.keepalive_interval)
        maximum_as_limit        = try(policy.maximum_as_limit, local.defaults.apic.tenants.policies.bgp_timer_policies.maximum_as_limit)
        stale_interval          = try(policy.stale_interval, local.defaults.apic.tenants.policies.bgp_timer_policies.stale_interval)
      }
    ]
  ])
}

module "aci_bgp_timer_policy" {
  source = "./modules/terraform-aci-bgp-timer-policy"

  for_each                = { for pol in local.bgp_timer_policies : pol.key => pol if local.modules.aci_bgp_timer_policy && var.manage_tenants }
  tenant                  = each.value.tenant
  name                    = each.value.name
  description             = each.value.description
  graceful_restart_helper = each.value.graceful_restart_helper
  hold_interval           = each.value.hold_interval
  keepalive_interval      = each.value.keepalive_interval
  maximum_as_limit        = each.value.maximum_as_limit
  stale_interval          = each.value.stale_interval

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bgp_address_family_context_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bgp_address_family_context_policies, []) : {
        key                    = format("%s/%s", tenant.name, policy.name)
        tenant                 = tenant.name
        name                   = "${policy.name}${local.defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix}"
        description            = try(policy.description, "")
        enable_host_route_leak = try(policy.enable_host_route_leak, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.enable_host_route_leak)
        ebgp_distance          = try(policy.ebgp_distance, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_distance)
        ibgp_distance          = try(policy.ibgp_distance, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_distance)
        local_distance         = try(policy.local_distance, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.local_distance)
        local_max_ecmp         = try(policy.local_max_ecmp, 0)
        ebgp_max_ecmp          = try(policy.ebgp_max_ecmp, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_max_ecmp)
        ibgp_max_ecmp          = try(policy.ibgp_max_ecmp, local.defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_max_ecmp)
      }
    ]
  ])
}

module "aci_bgp_address_family_context_policy" {
  source = "./modules/terraform-aci-bgp-address-family-context-policy"

  for_each               = { for pol in local.bgp_address_family_context_policies : pol.key => pol if local.modules.aci_bgp_address_family_context_policy && var.manage_tenants }
  tenant                 = each.value.tenant
  name                   = each.value.name
  description            = each.value.description
  enable_host_route_leak = each.value.enable_host_route_leak
  ebgp_distance          = each.value.ebgp_distance
  ibgp_distance          = each.value.ibgp_distance
  local_distance         = each.value.local_distance
  local_max_ecmp         = each.value.local_max_ecmp
  ebgp_max_ecmp          = each.value.ebgp_max_ecmp
  ibgp_max_ecmp          = each.value.ibgp_max_ecmp

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  dhcp_relay_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.dhcp_relay_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix}"
        description = try(policy.description, "")
        providers_ = [for provider in try(policy.providers, []) : {
          ip                      = provider.ip
          type                    = provider.type
          tenant                  = try(provider.tenant, tenant.name)
          application_profile     = try("${provider.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}", "")
          endpoint_group          = try("${provider.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}", "")
          l3out                   = try("${provider.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
          external_endpoint_group = try("${provider.external_endpoint_group}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
        }]
      }
    ]
  ])
}

module "aci_dhcp_relay_policy" {
  source = "./modules/terraform-aci-dhcp-relay-policy"

  for_each    = { for policy in local.dhcp_relay_policies : policy.key => policy if local.modules.aci_dhcp_relay_policy && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  providers_  = each.value.providers_

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  dhcp_option_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.dhcp_option_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.dhcp_option_policies.name_suffix}"
        description = try(policy.description, "")
        options     = try(policy.options, [])
      }
    ]
  ])
}

module "aci_dhcp_option_policy" {
  source = "./modules/terraform-aci-dhcp-option-policy"

  for_each    = { for policy in local.dhcp_option_policies : policy.key => policy if local.modules.aci_dhcp_option_policy && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  options     = each.value.options

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  endpoint_retention_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.endpoint_retention_policies, []) : {
        key                            = format("%s/%s", tenant.name, policy.name)
        tenant                         = tenant.name
        name                           = "${policy.name}${local.defaults.apic.tenants.policies.endpoint_retention_policies.name_suffix}"
        description                    = try(policy.description, "")
        hold_interval                  = try(policy.hold_interval, local.defaults.apic.tenants.policies.endpoint_retention_policies.hold_interval)
        bounce_entry_aging_interval    = try(policy.bounce_entry_aging_interval, local.defaults.apic.tenants.policies.endpoint_retention_policies.bounce_entry_aging_interval)
        local_endpoint_aging_interval  = try(policy.local_endpoint_aging_interval, local.defaults.apic.tenants.policies.endpoint_retention_policies.local_endpoint_aging_interval)
        remote_endpoint_aging_interval = try(policy.remote_endpoint_aging_interval, local.defaults.apic.tenants.policies.endpoint_retention_policies.remote_endpoint_aging_interval)
        move_frequency                 = try(policy.move_frequency, local.defaults.apic.tenants.policies.endpoint_retention_policies.move_frequency)
      }
    ]
  ])
}

module "aci_endpoint_retention_policy" {
  source = "./modules/terraform-aci-endpoint-retention-policy"

  for_each                       = { for policy in local.endpoint_retention_policies : policy.key => policy if local.modules.aci_endpoint_retention_policy && var.manage_tenants }
  tenant                         = each.value.tenant
  name                           = each.value.name
  description                    = each.value.description
  hold_interval                  = each.value.hold_interval
  bounce_entry_aging_interval    = each.value.bounce_entry_aging_interval
  local_endpoint_aging_interval  = each.value.local_endpoint_aging_interval
  remote_endpoint_aging_interval = each.value.remote_endpoint_aging_interval
  move_frequency                 = each.value.move_frequency

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  route_control_route_maps = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.route_control_route_maps, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.route_control_route_maps.name_suffix}"
        description = try(policy.description, "")
        type        = try(policy.type, local.defaults.apic.tenants.policies.route_control_route_maps.type)
        contexts = [for ctx in try(policy.contexts, []) : {
          name        = "${ctx.name}${local.defaults.apic.tenants.policies.route_control_route_maps.contexts.name_suffix}"
          description = try(ctx.description, "")
          action      = try(ctx.action, local.defaults.apic.tenants.policies.route_control_route_maps.contexts.action)
          order       = try(ctx.order, local.defaults.apic.tenants.policies.route_control_route_maps.contexts.order)
          set_rule    = try("${ctx.set_rule}${local.defaults.apic.tenants.policies.set_rules.name_suffix}", "")
          match_rules = [for mr in try(ctx.match_rules, []) : "${mr}${local.defaults.apic.tenants.policies.match_rules.name_suffix}"]
        }]
      }
    ]
  ])
}

module "aci_route_control_route_map" {
  source = "./modules/terraform-aci-route-control-route-map"

  for_each    = { for rm in local.route_control_route_maps : rm.key => rm if local.modules.aci_route_control_route_map && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  type        = each.value.type
  contexts    = each.value.contexts

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  ip_sla_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.ip_sla_policies, []) : {
        key          = format("%s/%s", tenant.name, policy.name)
        tenant       = tenant.name
        name         = "${policy.name}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}"
        description  = try(policy.description, "")
        multiplier   = try(policy.multiplier, local.defaults.apic.tenants.policies.ip_sla_policies.multiplier)
        frequency    = try(policy.frequency, local.defaults.apic.tenants.policies.ip_sla_policies.frequency)
        sla_type     = try(policy.sla_type, local.defaults.apic.tenants.policies.ip_sla_policies.sla_type)
        port         = try(policy.port, local.defaults.apic.tenants.policies.ip_sla_policies.port)
        http_method  = try(policy.sla_type, local.defaults.apic.tenants.policies.ip_sla_policies.sla_type) == "http" ? try(policy.http_method, local.defaults.apic.tenants.policies.ip_sla_policies.http_method) : null
        http_version = try(policy.sla_type, local.defaults.apic.tenants.policies.ip_sla_policies.sla_type) == "http" ? try(policy.http_version, local.defaults.apic.tenants.policies.ip_sla_policies.http_version) : null
        http_uri     = try(policy.sla_type, local.defaults.apic.tenants.policies.ip_sla_policies.sla_type) == "http" ? try(policy.http_uri, local.defaults.apic.tenants.policies.ip_sla_policies.http_uri) : null
      }
    ]
  ])
}

module "aci_ip_sla_policy" {
  source = "./modules/terraform-aci-ip-sla-policy"

  for_each     = { for policy in local.ip_sla_policies : policy.key => policy if local.modules.aci_ip_sla_policy && var.manage_tenants }
  tenant       = each.value.tenant
  name         = each.value.name
  description  = each.value.description
  multiplier   = each.value.multiplier
  frequency    = each.value.frequency
  sla_type     = each.value.sla_type
  port         = each.value.port
  http_method  = each.value.http_method
  http_version = each.value.http_version
  http_uri     = each.value.http_uri

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  match_rules = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.match_rules, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.match_rules.name_suffix}"
        description = try(policy.description, "")
        regex_community_terms = [for regex in try(policy.regex_community_terms, []) : {
          name        = "${regex.name}${local.defaults.apic.tenants.policies.match_rules.regex_community_terms.name_suffix}"
          regex       = regex.regex
          type        = try(regex.type, local.defaults.apic.tenants.policies.match_rules.regex_community_terms.type)
          description = try(regex.description, "")
        }]
        community_terms = [for comm in try(policy.community_terms, []) : {
          name        = "${comm.name}${local.defaults.apic.tenants.policies.match_rules.community_terms.name_suffix}"
          description = try(comm.description, "")
          factors = [for f in try(comm.factors, []) : {
            community   = f.community
            description = try(f.description, "")
            scope       = try(f.scope, local.defaults.apic.tenants.policies.match_rules.community_terms.factors.scope)
          }]
        }]
        prefixes = [for prefix in try(policy.prefixes, []) : {
          ip          = prefix.ip
          aggregate   = try(prefix.aggregate, local.defaults.apic.tenants.policies.match_rules.prefixes.aggregate)
          description = try(prefix.description, "")
          from_length = try(prefix.from_length, local.defaults.apic.tenants.policies.match_rules.prefixes.from_length)
          to_length   = try(prefix.to_length, local.defaults.apic.tenants.policies.match_rules.prefixes.to_length)
        }]
      }
    ]
  ])
}

module "aci_match_rule" {
  source = "./modules/terraform-aci-match-rule"

  for_each              = { for rule in local.match_rules : rule.key => rule if local.modules.aci_match_rule && var.manage_tenants }
  tenant                = each.value.tenant
  name                  = each.value.name
  description           = each.value.description
  regex_community_terms = each.value.regex_community_terms
  community_terms       = each.value.community_terms
  prefixes              = each.value.prefixes

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  set_rules = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.set_rules, []) : {
        key                         = format("%s/%s", tenant.name, policy.name)
        tenant                      = tenant.name
        name                        = "${policy.name}${local.defaults.apic.tenants.policies.set_rules.name_suffix}"
        description                 = try(policy.description, "")
        community                   = try(policy.community, "")
        community_mode              = try(policy.community_mode, local.defaults.apic.tenants.policies.set_rules.community_mode)
        tag                         = try(policy.tag, null)
        dampening                   = try(policy.dampening.half_life, null) != null || try(policy.dampening.max_suppress_time, null) != null || try(policy.dampening.reuse_limit, null) != null || try(policy.dampening.suppress_limit, null) != null
        dampening_half_life         = try(policy.dampening.half_life, local.defaults.apic.tenants.policies.set_rules.dampening.half_life)
        dampening_max_suppress_time = try(policy.dampening.max_suppress_time, local.defaults.apic.tenants.policies.set_rules.dampening.max_suppress_time)
        dampening_reuse_limit       = try(policy.dampening.reuse_limit, local.defaults.apic.tenants.policies.set_rules.dampening.reuse_limit)
        dampening_suppress_limit    = try(policy.dampening.suppress_limit, local.defaults.apic.tenants.policies.set_rules.dampening.suppress_limit)
        weight                      = try(policy.weight, null)
        next_hop                    = try(policy.next_hop, "")
        metric                      = try(policy.metric, null)
        preference                  = try(policy.preference, null)
        metric_type                 = try(policy.metric_type, "")
        additional_communities = [
          for comm in try(policy.additional_communities, []) : {
            community   = comm.community
            description = try(comm.description, "")
          }
        ]
        set_as_paths = [
          for as_path in try(policy.set_as_paths, []) : {
            criteria = try(as_path.criteria, local.defaults.apic.tenants.policies.set_rules.set_as_paths.criteria)
            count    = try(as_path.count, local.defaults.apic.tenants.policies.set_rules.set_as_paths.count)
            asns = [
              for asn in try(as_path.asns, []) : {
                asn_number = asn.number
                order      = try(asn.order, local.defaults.apic.tenants.policies.set_rules.set_as_paths.asns.order)
              }
            ]
          }
        ]
        next_hop_propagation           = try(policy.next_hop_propagation, local.defaults.apic.tenants.policies.set_rules.next_hop_propagation)
        multipath                      = try(policy.multipath, local.defaults.apic.tenants.policies.set_rules.multipath)
        external_endpoint_group        = try(policy.external_endpoint_group.name, null) != null ? "${policy.external_endpoint_group.name}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}" : ""
        external_endpoint_group_l3out  = try(policy.external_endpoint_group.l3out, null) != null ? "${policy.external_endpoint_group.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}" : ""
        external_endpoint_group_tenant = try(policy.external_endpoint_group.tenant, tenant.name)
        endpoint_security_group        = try(policy.endpoint_security_group.name, null) != null ? "${policy.endpoint_security_group.name}${local.defaults.apic.tenants.application_profiles.name_suffix}" : ""
        endpoint_security_group_app    = try(policy.endpoint_security_group.app, null) != null ? "${policy.endpoint_security_group.app}${local.defaults.apic.tenants.application_profiles.endpoint_security_groups.name_suffix}" : ""
        endpoint_security_group_tenant = try(policy.endpoint_security_group.tenant, tenant.name)
      }
    ]
  ])
}

module "aci_set_rule" {
  source = "./modules/terraform-aci-set-rule"

  for_each                       = { for rule in local.set_rules : rule.key => rule if local.modules.aci_set_rule && var.manage_tenants }
  tenant                         = each.value.tenant
  name                           = each.value.name
  description                    = each.value.description
  community                      = each.value.community
  community_mode                 = each.value.community_mode
  tag                            = each.value.tag
  dampening                      = each.value.dampening
  dampening_half_life            = each.value.dampening_half_life
  dampening_max_suppress_time    = each.value.dampening_max_suppress_time
  dampening_reuse_limit          = each.value.dampening_reuse_limit
  dampening_suppress_limit       = each.value.dampening_suppress_limit
  weight                         = each.value.weight
  next_hop                       = each.value.next_hop
  metric                         = each.value.metric
  preference                     = each.value.preference
  metric_type                    = each.value.metric_type
  additional_communities         = each.value.additional_communities
  set_as_paths                   = each.value.set_as_paths
  next_hop_propagation           = each.value.next_hop_propagation
  multipath                      = each.value.multipath
  external_endpoint_group        = each.value.external_endpoint_group
  external_endpoint_group_l3out  = each.value.external_endpoint_group_l3out
  external_endpoint_group_tenant = each.value.external_endpoint_group_tenant

  depends_on = [
    module.aci_tenant,
    module.aci_external_endpoint_group,
  ]
}

locals {
  bfd_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bfd_interface_policies, []) : {
        key                       = format("%s/%s", tenant.name, policy.name)
        tenant                    = tenant.name
        name                      = "${policy.name}${local.defaults.apic.tenants.policies.bfd_interface_policies.name_suffix}"
        description               = try(policy.description, "")
        subinterface_optimization = try(policy.subinterface_optimization, local.defaults.apic.tenants.policies.bfd_interface_policies.subinterface_optimization)
        detection_multiplier      = try(policy.detection_multiplier, local.defaults.apic.tenants.policies.bfd_interface_policies.detection_multiplier)
        echo_admin_state          = try(policy.echo_admin_state, local.defaults.apic.tenants.policies.bfd_interface_policies.echo_admin_state)
        echo_rx_interval          = try(policy.echo_rx_interval, local.defaults.apic.tenants.policies.bfd_interface_policies.echo_rx_interval)
        min_rx_interval           = try(policy.min_rx_interval, local.defaults.apic.tenants.policies.bfd_interface_policies.min_rx_interval)
        min_tx_interval           = try(policy.min_tx_interval, local.defaults.apic.tenants.policies.bfd_interface_policies.min_tx_interval)
      }
    ]
  ])
}

module "aci_bfd_interface_policy" {
  source = "./modules/terraform-aci-bfd-interface-policy"

  for_each                  = { for pol in local.bfd_interface_policies : pol.key => pol if local.modules.aci_bfd_interface_policy && var.manage_tenants }
  tenant                    = each.value.tenant
  name                      = each.value.name
  description               = each.value.description
  subinterface_optimization = each.value.subinterface_optimization
  detection_multiplier      = each.value.detection_multiplier
  echo_admin_state          = each.value.echo_admin_state
  echo_rx_interval          = each.value.echo_rx_interval
  min_rx_interval           = each.value.min_rx_interval
  min_tx_interval           = each.value.min_tx_interval

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  hsrp_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.hsrp_interface_policies, []) : {
        key          = format("%s/%s", tenant.name, policy.name)
        tenant       = tenant.name
        name         = "${policy.name}${local.defaults.apic.tenants.policies.hsrp_interface_policies.name_suffix}"
        description  = try(policy.description, "")
        bfd_enable   = try(policy.bfd_enable, local.defaults.apic.tenants.policies.hsrp_interface_policies.bfd_enable)
        use_bia      = try(policy.use_bia, local.defaults.apic.tenants.policies.hsrp_interface_policies.use_bia)
        delay        = try(policy.delay, local.defaults.apic.tenants.policies.hsrp_interface_policies.delay)
        reload_delay = try(policy.reload_delay, local.defaults.apic.tenants.policies.hsrp_interface_policies.reload_delay)
      }
    ]
  ])
}

module "aci_hsrp_interface_policy" {
  source = "./modules/terraform-aci-hsrp-interface-policy"

  for_each     = { for pol in local.hsrp_interface_policies : pol.key => pol if local.modules.aci_hsrp_interface_policy && var.manage_tenants }
  tenant       = each.value.tenant
  name         = each.value.name
  description  = each.value.description
  bfd_enable   = each.value.bfd_enable
  use_bia      = each.value.use_bia
  delay        = each.value.delay
  reload_delay = each.value.reload_delay

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  hsrp_group_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.hsrp_group_policies, []) : {
        key                  = format("%s/%s", tenant.name, policy.name)
        tenant               = tenant.name
        name                 = "${policy.name}${local.defaults.apic.tenants.policies.hsrp_group_policies.name_suffix}"
        description          = try(policy.description, "")
        preempt              = try(policy.preempt, local.defaults.apic.tenants.policies.hsrp_group_policies.preempt)
        hello_interval       = try(policy.hello_interval, local.defaults.apic.tenants.policies.hsrp_group_policies.hello_interval)
        hold_interval        = try(policy.hold_interval, local.defaults.apic.tenants.policies.hsrp_group_policies.hold_interval)
        priority             = try(policy.priority, local.defaults.apic.tenants.policies.hsrp_group_policies.priority)
        auth_type            = try(policy.auth_type, local.defaults.apic.tenants.policies.hsrp_group_policies.auth_type)
        auth_key             = try(policy.key, "")
        preempt_delay_min    = try(policy.preempt_delay_min, local.defaults.apic.tenants.policies.hsrp_group_policies.preempt_delay_min)
        preempt_delay_reload = try(policy.preempt_delay_reload, local.defaults.apic.tenants.policies.hsrp_group_policies.preempt_delay_reload)
        preempt_delay_max    = try(policy.preempt_delay_max, local.defaults.apic.tenants.policies.hsrp_group_policies.preempt_delay_max)
        timeout              = try(policy.timeout, local.defaults.apic.tenants.policies.hsrp_group_policies.timeout)
      }
    ]
  ])
}

module "aci_hsrp_group_policy" {
  source = "./modules/terraform-aci-hsrp-group-policy"

  for_each             = { for pol in local.hsrp_group_policies : pol.key => pol if local.modules.aci_hsrp_group_policy && var.manage_tenants }
  tenant               = each.value.tenant
  name                 = each.value.name
  description          = each.value.description
  preempt              = each.value.preempt
  hello_interval       = each.value.hello_interval
  hold_interval        = each.value.hold_interval
  priority             = each.value.priority
  auth_type            = each.value.auth_type
  auth_key             = each.value.auth_key
  preempt_delay_min    = each.value.preempt_delay_min
  preempt_delay_reload = each.value.preempt_delay_reload
  preempt_delay_max    = each.value.preempt_delay_max
  timeout              = each.value.timeout

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  qos_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.qos, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.qos.name_suffix}"
        description = try(policy.description, "")
        alias       = try(policy.alias, "")
        dscp_priority_maps = [
          for map in try(policy.dscp_priority_maps, []) : {
            dscp_from   = map.dscp_from
            dscp_to     = map.dscp_to
            priority    = try(map.priority, local.defaults.apic.tenants.policies.qos.dscp_priority_maps.priority)
            dscp_target = try(map.dscp_target, local.defaults.apic.tenants.policies.qos.dscp_priority_maps.dscp_target)
            cos_target  = try(map.cos_target, local.defaults.apic.tenants.policies.qos.dscp_priority_maps.cos_target)
          }
        ]
        dot1p_classifiers = [
          for c in try(policy.dot1p_classifiers, []) : {
            dot1p_from  = c.dot1p_from
            dot1p_to    = c.dot1p_to
            priority    = try(c.priority, local.defaults.apic.tenants.policies.qos.dot1p_classifiers.priority)
            dscp_target = try(c.dscp_target, local.defaults.apic.tenants.policies.qos.dot1p_classifiers.dscp_target)
            cos_target  = try(c.cos_target, local.defaults.apic.tenants.policies.qos.dot1p_classifiers.cos_target)
          }
        ]
      }
    ]
  ])
}

module "aci_qos_policy" {
  source = "./modules/terraform-aci-qos-policy"

  for_each           = { for pol in local.qos_policies : pol.key => pol if local.modules.aci_qos_policy && var.manage_tenants }
  tenant             = each.value.tenant
  name               = each.value.name
  description        = each.value.description
  alias              = each.value.alias
  dscp_priority_maps = each.value.dscp_priority_maps
  dot1p_classifiers  = each.value.dot1p_classifiers

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  mpls_custom_qos_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.mpls_custom_qos_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        name        = "${policy.name}${local.defaults.apic.tenants.policies.mpls_custom_qos_policies.name_suffix}"
        description = try(policy.description, "")
        alias       = try(policy.alias, "")
        ingress_rules = [
          for ing in try(policy.ingress_rules, []) : {
            exp_from    = ing.exp_from
            exp_to      = ing.exp_to
            priority    = try(ing.priority, local.defaults.apic.tenants.policies.mpls_custom_qos_policies.ingress_rules.priority)
            dscp_target = try(ing.dscp_target, local.defaults.apic.tenants.policies.mpls_custom_qos_policies.ingress_rules.dscp_target)
            cos_target  = try(ing.cos_target, local.defaults.apic.tenants.policies.mpls_custom_qos_policies.ingress_rules.cos_target)
          }
        ]
        egress_rules = [
          for eg in try(policy.egress_rules, []) : {
            dscp_from  = eg.dscp_from
            dscp_to    = eg.dscp_to
            exp_target = try(eg.exp_target, local.defaults.apic.tenants.policies.mpls_custom_qos_policies.egress_rules.exp_target)
            cos_target = try(eg.cos_target, local.defaults.apic.tenants.policies.mpls_custom_qos_policies.egress_rules.cos_target)
          }
        ]
      }
    ] if tenant.name == "infra"
  ])
}

locals {
  tenant_data_plane_policing_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.data_plane_policing_policies, []) : {
        key                  = format("%s/%s", tenant.name, policy.name)
        tenant               = tenant.name
        name                 = "${policy.name}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}"
        admin_state          = try(policy.admin_state, local.defaults.apic.tenants.policies.data_plane_policing_policies.admin_state)
        mode                 = try(policy.mode, local.defaults.apic.tenants.policies.data_plane_policing_policies.mode)
        type                 = try(policy.type, local.defaults.apic.tenants.policies.data_plane_policing_policies.type)
        sharing_mode         = try(policy.sharing_mode, local.defaults.apic.tenants.policies.data_plane_policing_policies.sharing_mode)
        conform_action       = try(policy.conform_action, local.defaults.apic.tenants.policies.data_plane_policing_policies.conform_action)
        conform_mark_cos     = try(policy.conform_action == "mark", false) ? try(policy.conform_mark_cos, local.defaults.apic.tenants.policies.data_plane_policing_policies.conform_mark_cos) : null
        conform_mark_dscp    = try(policy.conform_action == "mark", false) ? try(policy.conform_mark_dscp, local.defaults.apic.tenants.policies.data_plane_policing_policies.conform_mark_dscp) : null
        exceed_action        = try(policy.exceed_action, local.defaults.apic.tenants.policies.data_plane_policing_policies.exceed_action)
        exceed_mark_cos      = try(policy.exceed_action == "mark", false) ? try(policy.exceed_mark_cos, local.defaults.apic.tenants.policies.data_plane_policing_policies.exceed_mark_cos) : null
        exceed_mark_dscp     = try(policy.exceed_action == "mark", false) ? try(policy.exceed_mark_dscp, local.defaults.apic.tenants.policies.data_plane_policing_policies.exceed_mark_dscp) : null
        violate_action       = try(policy.violate_action, local.defaults.apic.tenants.policies.data_plane_policing_policies.violate_action)
        violate_mark_cos     = try(policy.violate_action == "mark", false) ? try(policy.violate_mark_cos, local.defaults.apic.tenants.policies.data_plane_policing_policies.violate_mark_cos) : null
        violate_mark_dscp    = try(policy.violate_action == "mark", false) ? try(policy.violate_mark_dscp, local.defaults.apic.tenants.policies.data_plane_policing_policies.violate_mark_dscp) : null
        rate                 = try(policy.rate, local.defaults.apic.tenants.policies.data_plane_policing_policies.rate)
        rate_unit            = try(policy.rate_unit, local.defaults.apic.tenants.policies.data_plane_policing_policies.rate_unit)
        burst                = try(policy.burst, local.defaults.apic.tenants.policies.data_plane_policing_policies.burst)
        burst_unit           = try(policy.burst_unit, local.defaults.apic.tenants.policies.data_plane_policing_policies.burst_unit)
        peak_rate            = try(policy.type == "2R3C", false) ? try(policy.peak_rate, local.defaults.apic.tenants.policies.data_plane_policing_policies.peak_rate) : null
        peak_rate_unit       = try(policy.type == "2R3C", false) ? try(policy.peak_rate_unit, local.defaults.apic.tenants.policies.data_plane_policing_policies.peak_rate_unit) : null
        burst_excessive      = try(policy.type == "2R3C", false) ? try(policy.burst_excessive, local.defaults.apic.tenants.policies.data_plane_policing_policies.burst_excessive) : null
        burst_excessive_unit = try(policy.type == "2R3C", false) ? try(policy.burst_excessive_unit, local.defaults.apic.tenants.policies.data_plane_policing_policies.burst_excessive_unit) : null
      }
    ]
  ])
}

module "aci_tenant_data_plane_policing_policy" {
  source = "./modules/terraform-aci-data-plane-policing-policy"

  for_each             = { for dpp in try(local.tenant_data_plane_policing_policies, []) : dpp.name => dpp if local.modules.aci_data_plane_policing_policy && var.manage_tenants }
  name                 = "${each.value.name}${local.defaults.apic.tenants.policies.data_plane_policing_policies.name_suffix}"
  tenant               = each.value.tenant
  admin_state          = each.value.admin_state
  type                 = each.value.type
  mode                 = each.value.mode
  sharing_mode         = each.value.sharing_mode
  rate                 = each.value.rate
  rate_unit            = each.value.rate_unit
  burst                = each.value.burst
  burst_unit           = each.value.burst_unit
  conform_action       = each.value.conform_action
  conform_mark_cos     = each.value.conform_mark_cos
  conform_mark_dscp    = each.value.conform_mark_dscp
  exceed_action        = each.value.exceed_action
  exceed_mark_cos      = each.value.exceed_mark_cos
  exceed_mark_dscp     = each.value.exceed_mark_dscp
  violate_action       = each.value.violate_action
  violate_mark_cos     = each.value.violate_mark_cos
  violate_mark_dscp    = each.value.violate_mark_dscp
  peak_rate            = each.value.peak_rate
  peak_rate_unit       = each.value.peak_rate_unit
  burst_excessive      = each.value.burst_excessive
  burst_excessive_unit = each.value.burst_excessive_unit

  depends_on = [
    module.aci_tenant,
  ]
}

module "aci_mpls_custom_qos_policy" {
  source = "./modules/terraform-aci-mpls-custom-qos-policy"

  for_each      = { for pol in local.mpls_custom_qos_policies : pol.key => pol if local.modules.aci_mpls_custom_qos_policy && var.manage_tenants }
  name          = each.value.name
  description   = each.value.description
  alias         = each.value.alias
  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bgp_peer_prefix_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bgp_peer_prefix_policies, []) : {
        key          = format("%s/%s", tenant.name, policy.name)
        tenant       = tenant.name
        name         = "${policy.name}${local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.name_suffix}"
        description  = try(policy.description, "")
        action       = try(policy.action, local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.action)
        max_prefixes = try(policy.max_prefixes, local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.max_prefixes)
        restart_time = try(policy.restart_time, local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.restart_time)
        threshold    = try(policy.threshold, local.defaults.apic.tenants.policies.bgp_peer_prefix_policies.threshold)
      }
    ]
  ])
}

module "aci_bgp_peer_prefix_policy" {
  source = "./modules/terraform-aci-bgp-peer-prefix-policy"

  for_each     = { for pol in local.bgp_peer_prefix_policies : pol.key => pol if local.modules.aci_bgp_peer_prefix_policy && var.manage_tenants }
  tenant       = each.value.tenant
  name         = each.value.name
  description  = each.value.description
  action       = each.value.action
  max_prefixes = each.value.max_prefixes
  restart_time = each.value.restart_time
  threshold    = each.value.threshold

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bgp_best_path_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bgp_best_path_policies, []) : {
        key                     = format("%s/%s", tenant.name, policy.name)
        tenant                  = tenant.name
        name                    = "${policy.name}${local.defaults.apic.tenants.policies.bgp_best_path_policies.name_suffix}"
        description             = try(policy.description, "")
        as_path_multipath_relax = try(policy.as_path_multipath_relax, local.defaults.apic.tenants.policies.bgp_best_path_policies.as_path_multipath_relax)
        ignore_igp_metric       = try(policy.ignore_igp_metric, local.defaults.apic.tenants.policies.bgp_best_path_policies.ignore_igp_metric)
      }
    ]
  ])
}

module "aci_bgp_best_path_policy" {
  source = "./modules/terraform-aci-bgp-best-path-policy"

  for_each                = { for pol in local.bgp_best_path_policies : pol.key => pol if local.modules.aci_bgp_best_path_policy && var.manage_tenants }
  tenant                  = each.value.tenant
  name                    = each.value.name
  description             = each.value.description
  as_path_multipath_relax = each.value.as_path_multipath_relax
  ignore_igp_metric       = each.value.ignore_igp_metric

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  igmp_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.igmp_interface_policies, []) : {
        key                               = format("%s/%s", tenant.name, policy.name)
        tenant                            = tenant.name
        name                              = "${policy.name}${local.defaults.apic.tenants.policies.igmp_interface_policies.name_suffix}"
        description                       = try(policy.description, "")
        grp_timeout                       = try(policy.grp_timeout, local.defaults.apic.tenants.policies.igmp_interface_policies.grp_timeout)
        allow_v3_asm                      = try(policy.allow_v3_asm, local.defaults.apic.tenants.policies.igmp_interface_policies.allow_v3_asm)
        fast_leave                        = try(policy.fast_leave, local.defaults.apic.tenants.policies.igmp_interface_policies.fast_leave)
        report_link_local_groups          = try(policy.report_link_local_groups, local.defaults.apic.tenants.policies.igmp_interface_policies.report_link_local_groups)
        last_member_count                 = try(policy.last_member_count, local.defaults.apic.tenants.policies.igmp_interface_policies.last_member_count)
        last_member_response_time         = try(policy.last_member_response_time, local.defaults.apic.tenants.policies.igmp_interface_policies.last_member_response_time)
        querier_timeout                   = try(policy.querier_timeout, local.defaults.apic.tenants.policies.igmp_interface_policies.querier_timeout)
        query_interval                    = try(policy.query_interval, local.defaults.apic.tenants.policies.igmp_interface_policies.query_interval)
        robustness_variable               = try(policy.robustness_variable, local.defaults.apic.tenants.policies.igmp_interface_policies.robustness_variable)
        query_response_interval           = try(policy.query_response_interval, local.defaults.apic.tenants.policies.igmp_interface_policies.query_response_interval)
        startup_query_count               = try(policy.startup_query_count, local.defaults.apic.tenants.policies.igmp_interface_policies.startup_query_count)
        startup_query_interval            = try(policy.startup_query_interval, local.defaults.apic.tenants.policies.igmp_interface_policies.startup_query_interval)
        version_                          = try(policy.version, local.defaults.apic.tenants.policies.igmp_interface_policies.version)
        max_mcast_entries                 = try(policy.max_mcast_entries, local.defaults.apic.tenants.policies.igmp_interface_policies.max_mcast_entries)
        reserved_mcast_entries            = try(policy.reserved_mcast_entries, local.defaults.apic.tenants.policies.igmp_interface_policies.reserved_mcast_entries)
        report_policy_multicast_route_map = try(policy.report_policy_multicast_route_map, null) != null ? "${policy.report_policy_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        static_report_multicast_route_map = try(policy.static_report_multicast_route_map, null) != null ? "${policy.static_report_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
        state_limit_multicast_route_map   = try(policy.state_limit_multicast_route_map, null) != null ? "${policy.state_limit_multicast_route_map}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}" : ""
      }
    ]
  ])
}

module "aci_igmp_interface_policy" {
  source = "./modules/terraform-aci-igmp-interface-policy"

  for_each                          = { for pol in local.igmp_interface_policies : pol.key => pol if local.modules.aci_igmp_interface_policy && var.manage_tenants }
  tenant                            = each.value.tenant
  name                              = each.value.name
  description                       = each.value.description
  grp_timeout                       = each.value.grp_timeout
  allow_v3_asm                      = each.value.allow_v3_asm
  fast_leave                        = each.value.fast_leave
  report_link_local_groups          = each.value.report_link_local_groups
  last_member_count                 = each.value.last_member_count
  last_member_response_time         = each.value.last_member_response_time
  querier_timeout                   = each.value.querier_timeout
  query_interval                    = each.value.query_interval
  robustness_variable               = each.value.robustness_variable
  query_response_interval           = each.value.query_response_interval
  startup_query_count               = each.value.startup_query_count
  startup_query_interval            = each.value.startup_query_interval
  version_                          = each.value.version_
  max_mcast_entries                 = each.value.max_mcast_entries
  reserved_mcast_entries            = each.value.reserved_mcast_entries
  report_policy_multicast_route_map = each.value.report_policy_multicast_route_map
  static_report_multicast_route_map = each.value.static_report_multicast_route_map
  state_limit_multicast_route_map   = each.value.state_limit_multicast_route_map

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  igmp_snooping_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.igmp_snooping_policies, []) : {
        key                        = format("%s/%s", tenant.name, policy.name)
        tenant                     = tenant.name
        name                       = "${policy.name}${local.defaults.apic.tenants.policies.igmp_snooping_policies.name_suffix}"
        description                = try(policy.description, "")
        admin_state                = try(policy.admin_state, local.defaults.apic.tenants.policies.igmp_snooping_policies.admin_state)
        fast_leave                 = try(policy.fast_leave, local.defaults.apic.tenants.policies.igmp_snooping_policies.fast_leave)
        querier                    = try(policy.querier, local.defaults.apic.tenants.policies.igmp_snooping_policies.querier)
        last_member_query_interval = try(policy.last_member_query_interval, local.defaults.apic.tenants.policies.igmp_snooping_policies.last_member_query_interval)
        query_interval             = try(policy.query_interval, local.defaults.apic.tenants.policies.igmp_snooping_policies.query_interval)
        query_response_interval    = try(policy.query_response_interval, local.defaults.apic.tenants.policies.igmp_snooping_policies.query_response_interval)
        start_query_count          = try(policy.start_query_count, local.defaults.apic.tenants.policies.igmp_snooping_policies.start_query_count)
        start_query_interval       = try(policy.start_query_interval, local.defaults.apic.tenants.policies.igmp_snooping_policies.start_query_interval)
      }
    ]
  ])
}

module "aci_igmp_snooping_policy" {
  source = "./modules/terraform-aci-igmp-snooping-policy"

  for_each                   = { for pol in local.igmp_snooping_policies : pol.key => pol if local.modules.aci_igmp_snooping_policy && var.manage_tenants }
  tenant                     = each.value.tenant
  name                       = each.value.name
  description                = each.value.description
  admin_state                = each.value.admin_state
  fast_leave                 = each.value.fast_leave
  querier                    = each.value.querier
  last_member_query_interval = each.value.last_member_query_interval
  query_interval             = each.value.query_interval
  query_response_interval    = each.value.query_response_interval
  start_query_count          = each.value.start_query_count
  start_query_interval       = each.value.start_query_interval

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  pim_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.pim_policies, []) : {
        key                          = format("%s/%s", tenant.name, policy.name)
        tenant                       = tenant.name
        name                         = "${policy.name}${local.defaults.apic.tenants.policies.pim_policies.name_suffix}"
        auth_key                     = try(policy.auth_key, null)
        auth_type                    = try(policy.auth_type, local.defaults.apic.tenants.policies.pim_policies.auth_type)
        mcast_dom_boundary           = try(policy.mcast_dom_boundary, local.defaults.apic.tenants.policies.pim_policies.mcast_dom_boundary)
        passive                      = try(policy.passive, local.defaults.apic.tenants.policies.pim_policies.passive)
        strict_rfc                   = try(policy.strict_rfc, local.defaults.apic.tenants.policies.pim_policies.strict_rfc)
        designated_router_delay      = try(policy.designated_router_delay, local.defaults.apic.tenants.policies.pim_policies.designated_router_delay)
        designated_router_priority   = try(policy.designated_router_priority, local.defaults.apic.tenants.policies.pim_policies.designated_router_priority)
        hello_interval               = try(policy.hello_interval, local.defaults.apic.tenants.policies.pim_policies.hello_interval)
        join_prune_interval          = try(policy.join_prune_interval, local.defaults.apic.tenants.policies.pim_policies.join_prune_interval)
        neighbor_filter_policy       = try("${policy.neighbor_filter_policy}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}", "")
        join_prune_filter_policy_in  = try("${policy.join_prune_filter_policy_in}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}", "")
        join_prune_filter_policy_out = try("${policy.join_prune_filter_policy_out}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}", "")
      }
    ]
  ])
}

module "aci_pim_policy" {
  source = "./modules/terraform-aci-pim-policy"

  for_each                     = { for pol in local.pim_policies : pol.key => pol if local.modules.aci_pim_policy && var.manage_tenants }
  tenant                       = each.value.tenant
  name                         = each.value.name
  auth_key                     = each.value.auth_key
  auth_type                    = each.value.auth_type
  mcast_dom_boundary           = each.value.mcast_dom_boundary
  passive                      = each.value.passive
  strict_rfc                   = each.value.strict_rfc
  designated_router_delay      = each.value.designated_router_delay
  designated_router_priority   = each.value.designated_router_priority
  hello_interval               = each.value.hello_interval
  join_prune_interval          = each.value.join_prune_interval
  neighbor_filter_policy       = each.value.neighbor_filter_policy
  join_prune_filter_policy_in  = each.value.join_prune_filter_policy_in
  join_prune_filter_policy_out = each.value.join_prune_filter_policy_out

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  trust_control_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.trust_control_policies, []) : {
        key            = format("%s/%s", tenant.name, policy.name)
        tenant         = tenant.name
        name           = "${policy.name}${local.defaults.apic.tenants.policies.trust_control_policies.name_suffix}"
        description    = try(policy.description, "")
        dhcp_v4_server = try(policy.dhcp_v4_server, local.defaults.apic.tenants.policies.trust_control_policies.dhcp_v4_server)
        dhcp_v6_server = try(policy.dhcp_v6_server, local.defaults.apic.tenants.policies.trust_control_policies.dhcp_v6_server)
        ipv6_router    = try(policy.ipv6_router, local.defaults.apic.tenants.policies.trust_control_policies.ipv6_router)
        arp            = try(policy.arp, local.defaults.apic.tenants.policies.trust_control_policies.arp)
        nd             = try(policy.nd, local.defaults.apic.tenants.policies.trust_control_policies.nd)
        ra             = try(policy.ra, local.defaults.apic.tenants.policies.trust_control_policies.ra)
      }
    ]
  ])
}

module "aci_trust_control_policy" {
  source = "./modules/terraform-aci-trust-control-policy"

  for_each       = { for pol in local.trust_control_policies : pol.key => pol if local.modules.aci_trust_control_policy && var.manage_tenants }
  tenant         = each.value.tenant
  name           = each.value.name
  description    = each.value.description
  dhcp_v4_server = each.value.dhcp_v4_server
  dhcp_v6_server = each.value.dhcp_v6_server
  ipv6_router    = each.value.ipv6_router
  arp            = each.value.arp
  nd             = each.value.nd
  ra             = each.value.ra

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  multicast_route_maps = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.multicast_route_maps, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.multicast_route_maps.name_suffix}"
        description = try(policy.description, "")
        entries = [for entry in try(policy.entries, []) : {
          order     = entry.order
          action    = try(entry.action, local.defaults.apic.tenants.policies.multicast_route_maps.entries.action)
          source_ip = try(entry.source_ip, local.defaults.apic.tenants.policies.multicast_route_maps.entries.source_ip)
          group_ip  = try(entry.group_ip, local.defaults.apic.tenants.policies.multicast_route_maps.entries.group_ip)
          rp_ip     = try(entry.rp_ip, local.defaults.apic.tenants.policies.multicast_route_maps.entries.rp_ip)
        }]
      }
    ]
  ])
}

module "aci_multicast_route_map" {
  source = "./modules/terraform-aci-multicast-route-map"

  for_each    = { for pol in local.multicast_route_maps : pol.key => pol if local.modules.aci_multicast_route_map && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  entries     = each.value.entries

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  route_tag_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.route_tag_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.route_tag_policies.name_suffix}"
        description = try(policy.description, "")
        tag         = try(policy.tag, local.defaults.apic.tenants.policies.route_tag_policies.tag)
      }
    ]
  ])
}

module "aci_route_tag_policy" {
  source = "./modules/terraform-aci-route-tag-policy"

  for_each    = { for pol in local.route_tag_policies : pol.key => pol if local.modules.aci_route_tag_policy && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  tag         = each.value.tag

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  bfd_multihop_node_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.bfd_multihop_node_policies, []) : {
        key                  = format("%s/%s", tenant.name, policy.name)
        tenant               = tenant.name
        name                 = "${policy.name}${local.defaults.apic.tenants.policies.bfd_multihop_node_policies.name_suffix}"
        description          = try(policy.description, "")
        detection_multiplier = try(policy.detection_multiplier, local.defaults.apic.tenants.policies.bfd_multihop_node_policies.detection_multiplier)
        min_rx_interval      = try(policy.min_rx_interval, local.defaults.apic.tenants.policies.bfd_multihop_node_policies.min_rx_interval)
        min_tx_interval      = try(policy.min_tx_interval, local.defaults.apic.tenants.policies.bfd_multihop_node_policies.min_tx_interval)
      }
    ]
  ])
}

module "aci_bfd_multihop_node_policy" {
  source = "./modules/terraform-aci-bfd-multihop-node-policy"

  for_each             = { for pol in local.bfd_multihop_node_policies : pol.key => pol if local.modules.aci_bfd_multihop_node_policy && var.manage_tenants }
  tenant               = each.value.tenant
  name                 = each.value.name
  description          = each.value.description
  detection_multiplier = each.value.detection_multiplier
  min_rx_interval      = each.value.min_rx_interval
  min_tx_interval      = each.value.min_tx_interval

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  nd_ra_prefix_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.nd_ra_prefix_policies, []) : {
        key                = format("%s/%s", tenant.name, policy.name)
        tenant             = tenant.name
        name               = "${policy.name}${local.defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix}"
        description        = try(policy.description, "")
        valid_lifetime     = try(policy.valid_lifetime, local.defaults.apic.tenants.policies.nd_ra_prefix_policies.valid_lifetime)
        preferred_lifetime = try(policy.preferred_lifetime, local.defaults.apic.tenants.policies.nd_ra_prefix_policies.preferred_lifetime)
        auto_configuration = try(policy.auto_configuration, local.defaults.apic.tenants.policies.nd_ra_prefix_policies.auto_configuration)
        on_link            = try(policy.on_link, local.defaults.apic.tenants.policies.nd_ra_prefix_policies.on_link)
        router_address     = try(policy.router_address, local.defaults.apic.tenants.policies.nd_ra_prefix_policies.router_address)
      }
    ]
  ])
}

locals {
  nd_interface_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.nd_interface_policies, []) : {
        key                      = format("%s/%s", tenant.name, policy.name)
        tenant                   = tenant.name
        name                     = "${policy.name}${local.defaults.apic.tenants.policies.nd_interface_policies.name_suffix}"
        description              = try(policy.description, "")
        controller_state         = [for state in try(policy.controller_state, []) : state]
        hop_limit                = try(policy.hop_limit, local.defaults.apic.tenants.policies.nd_interface_policies.hop_limit)
        ns_tx_interval           = try(policy.ns_tx_interval, local.defaults.apic.tenants.policies.nd_interface_policies.ns_tx_interval)
        mtu                      = try(policy.mtu, local.defaults.apic.tenants.policies.nd_interface_policies.mtu)
        retransmit_retry_count   = try(policy.retransmit_retry_count, local.defaults.apic.tenants.policies.nd_interface_policies.retransmit_retry_count)
        nud_retransmit_base      = try(policy.nud_retransmit_base, 0)
        nud_retransmit_interval  = try(policy.nud_retransmit_interval, 0)
        nud_retransmit_count     = try(policy.nud_retransmit_count, 0)
        route_advertise_interval = try(policy.route_advertise_interval, local.defaults.apic.tenants.policies.nd_interface_policies.route_advertise_interval)
        router_lifetime          = try(policy.router_lifetime, local.defaults.apic.tenants.policies.nd_interface_policies.router_lifetime)
        reachable_time           = try(policy.reachable_time, local.defaults.apic.tenants.policies.nd_interface_policies.reachable_time)
        retransmit_timer         = try(policy.retransmit_timer, local.defaults.apic.tenants.policies.nd_interface_policies.retransmit_timer)
      }
    ]
  ])
}

module "aci_nd_interface_policy" {
  source = "./modules/terraform-aci-nd-interface-policy"

  for_each                 = { for pol in local.nd_interface_policies : pol.key => pol if local.modules.aci_nd_interface_policy && var.manage_tenants }
  tenant                   = each.value.tenant
  name                     = each.value.name
  description              = each.value.description
  controller_state         = each.value.controller_state
  hop_limit                = each.value.hop_limit
  ns_tx_interval           = each.value.ns_tx_interval
  mtu                      = each.value.mtu
  retransmit_retry_count   = each.value.retransmit_retry_count
  nud_retransmit_base      = each.value.nud_retransmit_base
  nud_retransmit_interval  = each.value.nud_retransmit_interval
  nud_retransmit_count     = each.value.nud_retransmit_count
  route_advertise_interval = each.value.route_advertise_interval
  router_lifetime          = each.value.router_lifetime
  reachable_time           = each.value.reachable_time
  retransmit_timer         = each.value.retransmit_timer

  depends_on = [
    module.aci_tenant,
  ]
}

module "aci_nd_ra_prefix_policy" {
  source = "./modules/terraform-aci-nd-ra-prefix-policy"

  for_each           = { for pol in local.nd_ra_prefix_policies : pol.key => pol if local.modules.aci_nd_ra_prefix_policy && var.manage_tenants }
  tenant             = each.value.tenant
  name               = each.value.name
  description        = each.value.description
  valid_lifetime     = each.value.valid_lifetime
  preferred_lifetime = each.value.preferred_lifetime
  auto_configuration = each.value.auto_configuration
  on_link            = each.value.on_link
  router_address     = each.value.router_address

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  l4l7_devices = flatten([
    for tenant in local.tenants : [
      for device in try(tenant.services.l4l7_devices, []) : {
        key              = format("%s/%s", tenant.name, device.name)
        tenant           = tenant.name
        name             = "${device.name}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}"
        alias            = try(device.alias, "")
        context_aware    = try(device.context_aware, local.defaults.apic.tenants.services.l4l7_devices.context_aware)
        type             = try(device.type, local.defaults.apic.tenants.services.l4l7_devices.type)
        function         = try(device.function, local.defaults.apic.tenants.services.l4l7_devices.function)
        copy_device      = try(device.copy_device, local.defaults.apic.tenants.services.l4l7_devices.copy_device)
        managed          = try(device.managed, local.defaults.apic.tenants.services.l4l7_devices.managed)
        promiscuous_mode = try(device.promiscuous_mode, local.defaults.apic.tenants.services.l4l7_devices.promiscuous_mode)
        service_type     = try(device.service_type, local.defaults.apic.tenants.services.l4l7_devices.service_type)
        trunking         = try(device.trunking, local.defaults.apic.tenants.services.l4l7_devices.trunking)
        active_active    = try(device.active_active, local.defaults.apic.tenants.services.l4l7_devices.active_active)
        physical_domain  = try(device.physical_domain, "")
        vmm_provider     = "VMware"
        vmm_domain       = try(device.vmware_vmm_domain, "")
        concrete_devices = [for cdev in try(device.concrete_devices, []) : {
          name         = "${cdev.name}${local.defaults.apic.tenants.services.l4l7_devices.concrete_devices.name_suffix}"
          alias        = try(cdev.alias, null)
          vcenter_name = try(cdev.vcenter_name, null)
          vm_name      = try(cdev.vm_name, null)
          interfaces = [for int in try(cdev.interfaces, []) : {
            name      = "${int.name}${local.defaults.apic.tenants.services.l4l7_devices.concrete_devices.interfaces.name_suffix}"
            alias     = try(int.alias, null)
            vnic_name = try(int.vnic_name, null)
            node_id   = try(int.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == int.channel][0][0], null)
            # set node2_id to "vpc" if channel IPG is vPC, otherwise "null"
            node2_id = try(int.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == int.channel && pg.type == "vpc"][0], null)
            pod_id   = try(int.pod_id, null)
            fex_id   = try(int.fex_id, null)
            module   = try(int.module, null)
            port     = try(int.port, null)
            channel  = try("${int.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", null)
            vlan     = try(int.vlan, null)
          }]
        }]
        logical_interfaces = [for lint in try(device.logical_interfaces, []) : {
          name  = "${lint.name}${local.defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix}"
          alias = try(lint.alias, null)
          vlan  = try(lint.vlan, null)
          concrete_interfaces = [for cint in try(lint.concrete_interfaces, []) : {
            device    = cint.device
            interface = "${cint.interface_name}${local.defaults.apic.tenants.services.l4l7_devices.logical_interfaces.concrete_interfaces.name_suffix}"
          }]
        }]
      }
    ]
  ])
}

module "aci_l4l7_device" {
  source = "./modules/terraform-aci-l4l7-device"

  for_each         = { for device in local.l4l7_devices : device.key => device if local.modules.aci_l4l7_device && var.manage_tenants }
  tenant           = each.value.tenant
  name             = each.value.name
  alias            = each.value.alias
  context_aware    = each.value.context_aware
  type             = each.value.type
  function         = each.value.function
  copy_device      = each.value.copy_device
  managed          = each.value.managed
  promiscuous_mode = each.value.promiscuous_mode
  service_type     = each.value.service_type
  trunking         = each.value.trunking
  active_active    = each.value.active_active
  physical_domain  = each.value.physical_domain
  vmm_provider     = each.value.vmm_provider
  vmm_domain       = each.value.vmm_domain
  concrete_devices = [for cdev in try(each.value.concrete_devices, []) : {
    name         = cdev.name
    alias        = cdev.alias
    vcenter_name = cdev.vcenter_name
    vm_name      = cdev.vm_name
    interfaces = [for int in try(cdev.interfaces, []) : {
      name      = int.name
      alias     = int.alias
      vnic_name = int.vnic_name
      node_id   = int.node_id
      node2_id  = int.node2_id == "vpc" ? [for pg in local.leaf_interface_policy_group_mapping : try(pg.node_ids, []) if pg.name == int.channel][0][1] : int.node2_id
      pod_id    = int.pod_id == null ? try([for node in local.node_policies.nodes : node.pod if node.id == int.node_id][0], local.defaults.apic.node_policies.nodes.pod) : int.pod_id
      fex_id    = int.fex_id
      module    = int.module
      port      = int.port
      channel   = int.channel
      vlan      = int.vlan
    }]
  }]
  logical_interfaces = each.value.logical_interfaces

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  imported_l4l7_devices = flatten([
    for tenant in local.tenants : [
      for device in try(tenant.services.imported_l4l7_devices, []) : {
        key           = format("%s/%s", tenant.name, device.name)
        tenant        = tenant.name
        source_tenant = device.tenant
        source_device = "${device.name}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}"
        description   = try(device.description, "")
      }
    ]
  ])
}

module "aci_imported_l4l7_device" {
  source = "./modules/terraform-aci-imported-l4l7-device"

  for_each      = { for device in local.imported_l4l7_devices : device.key => device if local.modules.aci_imported_l4l7_device && var.manage_tenants }
  tenant        = each.value.tenant
  source_tenant = each.value.source_tenant
  source_device = each.value.source_device
  description   = each.value.description

  depends_on = [
    module.aci_tenant,
  ]
}


locals {
  redirect_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.services.redirect_policies, []) : {
        key                    = format("%s/%s", tenant.name, policy.name)
        tenant                 = tenant.name
        name                   = "${policy.name}${local.defaults.apic.tenants.services.redirect_policies.name_suffix}"
        alias                  = try(policy.alias, "")
        description            = try(policy.description, "")
        anycast                = try(policy.anycast, local.defaults.apic.tenants.services.redirect_policies.anycast)
        type                   = try(policy.type, local.defaults.apic.tenants.services.redirect_policies.type)
        hashing                = try(policy.hashing, local.defaults.apic.tenants.services.redirect_policies.hashing)
        threshold              = try(policy.threshold, local.defaults.apic.tenants.services.redirect_policies.threshold)
        max_threshold          = try(policy.max_threshold, local.defaults.apic.tenants.services.redirect_policies.max_threshold)
        min_threshold          = try(policy.min_threshold, local.defaults.apic.tenants.services.redirect_policies.min_threshold)
        pod_aware              = try(policy.pod_aware, local.defaults.apic.tenants.services.redirect_policies.pod_aware)
        resilient_hashing      = try(policy.resilient_hashing, local.defaults.apic.tenants.services.redirect_policies.resilient_hashing)
        threshold_down_action  = try(policy.threshold_down_action, local.defaults.apic.tenants.services.redirect_policies.threshold_down_action)
        ip_sla_policy          = try("${policy.ip_sla_policy}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}", "")
        ip_sla_policy_tenant   = !contains(try(local.tenant_shared_policies[tenant.name].ip_sla_policies, []), policy.ip_sla_policy) && contains(try(local.tenant_shared_policies["common"].ip_sla_policies, []), policy.ip_sla_policy) ? "common" : tenant.name
        redirect_backup_policy = try("${policy.redirect_backup_policy}${local.defaults.apic.tenants.services.redirect_backup_policies.name_suffix}", "")
        rewrite_source_mac     = try(policy.rewrite_source_mac, null)
        l3_destinations = [for dest in try(policy.l3_destinations, []) : {
          description           = try(dest.description, "")
          name                  = try(dest.name, "")
          ip                    = dest.ip
          ip_2                  = try(dest.ip_2, null)
          mac                   = try(dest.mac, null)
          pod_id                = try(dest.pod, local.defaults.apic.tenants.services.redirect_policies.l3_destinations.pod)
          redirect_health_group = try("${dest.redirect_health_group}${local.defaults.apic.tenants.services.redirect_health_groups.name_suffix}", "")
        }]
        l1l2_destinations = [for dest in try(policy.l1l2_destinations, []) : {
          description           = try(dest.description, "")
          name                  = dest.name
          mac                   = try(dest.mac, null)
          weight                = try(dest.weight, null)
          pod_id                = try(dest.pod, null)
          redirect_health_group = try("${dest.redirect_health_group}${local.defaults.apic.tenants.services.redirect_health_groups.name_suffix}", "")
          l4l7_device           = "${dest.concrete_interface.l4l7_device}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}"
          concrete_device       = "${dest.concrete_interface.concrete_device}${local.defaults.apic.tenants.services.l4l7_devices.concrete_devices.name_suffix}"
          interface             = "${dest.concrete_interface.interface}${local.defaults.apic.tenants.services.l4l7_devices.concrete_devices.interfaces.name_suffix}"
        }]
      }
    ]
  ])
}

module "aci_redirect_policy" {
  source = "./modules/terraform-aci-redirect-policy"

  for_each               = { for policy in local.redirect_policies : policy.key => policy if local.modules.aci_redirect_policy && var.manage_tenants }
  tenant                 = each.value.tenant
  name                   = each.value.name
  alias                  = each.value.alias
  description            = each.value.description
  anycast                = each.value.anycast
  type                   = each.value.type
  hashing                = each.value.hashing
  threshold              = each.value.threshold
  max_threshold          = each.value.max_threshold
  min_threshold          = each.value.min_threshold
  pod_aware              = each.value.pod_aware
  resilient_hashing      = each.value.resilient_hashing
  threshold_down_action  = each.value.threshold_down_action
  ip_sla_policy          = each.value.ip_sla_policy
  ip_sla_policy_tenant   = each.value.ip_sla_policy_tenant
  redirect_backup_policy = each.value.redirect_backup_policy
  l3_destinations        = each.value.l3_destinations
  l1l2_destinations      = each.value.l1l2_destinations
  rewrite_source_mac     = each.value.rewrite_source_mac

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  redirect_backup_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.services.redirect_backup_policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.services.redirect_backup_policies.name_suffix}"
        description = try(policy.description, "")
        l3_destinations = [for dest in try(policy.l3_destinations, []) : {
          name                  = try(dest.destination_name, "")
          description           = try(dest.description, "")
          ip                    = dest.ip
          ip_2                  = try(dest.ip_2, null)
          mac                   = try(dest.mac, null)
          redirect_health_group = try("${dest.redirect_health_group}${local.defaults.apic.tenants.services.redirect_health_groups.name_suffix}", "")
        }]
      }
    ]
  ])
}

module "aci_redirect_backup_policy" {
  source = "./modules/terraform-aci-redirect-backup-policy"

  for_each        = { for policy in local.redirect_backup_policies : policy.key => policy if local.modules.aci_redirect_backup_policy && var.manage_tenants }
  tenant          = each.value.tenant
  name            = each.value.name
  description     = each.value.description
  l3_destinations = each.value.l3_destinations

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  redirect_health_groups = flatten([
    for tenant in local.tenants : [
      for hg in try(tenant.services.redirect_health_groups, []) : {
        key         = format("%s/%s", tenant.name, hg.name)
        tenant      = tenant.name
        name        = "${hg.name}${local.defaults.apic.tenants.services.redirect_health_groups.name_suffix}"
        description = try(hg.description, "")
      }
    ]
  ])
}

module "aci_redirect_health_group" {
  source = "./modules/terraform-aci-redirect-health-group"

  for_each    = { for health_group in local.redirect_health_groups : health_group.key => health_group if local.modules.aci_redirect_health_group && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  service_graph_templates = flatten([
    for tenant in local.tenants : [
      for sgt in try(tenant.services.service_graph_templates, []) : {
        key                     = format("%s/%s", tenant.name, sgt.name)
        tenant                  = tenant.name
        name                    = "${sgt.name}${local.defaults.apic.tenants.services.service_graph_templates.name_suffix}"
        annotation              = try(sgt.ndo_managed, local.defaults.apic.tenants.services.service_graph_templates.ndo_managed) ? "orchestrator:msc-shadow:no" : null
        description             = try(sgt.description, "")
        alias                   = try(sgt.alias, "")
        template_type           = try(sgt.template_type, local.defaults.apic.tenants.services.service_graph_templates.template_type)
        redirect                = try(sgt.redirect, local.defaults.apic.tenants.services.service_graph_templates.redirect)
        share_encapsulation     = try(sgt.share_encapsulation, local.defaults.apic.tenants.services.service_graph_templates.share_encapsulation)
        device_name             = "${sgt.device.name}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}"
        device_tenant           = try(sgt.device.tenant, tenant.name)
        device_function         = length([for d in local.l4l7_devices : d if d.tenant == try(sgt.device.tenant, tenant.name)]) > 0 ? [for device in local.l4l7_devices : try(device.function, local.defaults.apic.tenants.services.l4l7_devices.function) if device.name == sgt.device.name && (device.tenant == try(sgt.device.tenant, tenant.name))][0] : local.defaults.apic.tenants.services.l4l7_devices.function
        device_copy             = length([for d in local.l4l7_devices : d if d.tenant == try(sgt.device.tenant, tenant.name)]) > 0 ? [for device in local.l4l7_devices : try(device.copy_device, local.defaults.apic.tenants.services.l4l7_devices.copy_device) if device.name == sgt.device.name && (device.tenant == try(sgt.device.tenant, tenant.name))][0] : local.defaults.apic.tenants.services.l4l7_devices.copy_device
        device_managed          = length([for d in local.l4l7_devices : d if d.tenant == try(sgt.device.tenant, tenant.name)]) > 0 ? [for device in local.l4l7_devices : try(device.managed, local.defaults.apic.tenants.services.l4l7_devices.managed) if device.name == sgt.device.name && (device.tenant == try(sgt.device.tenant, tenant.name))][0] : local.defaults.apic.tenants.services.l4l7_devices.managed
        device_node_name        = (length([for d in local.l4l7_devices : d if d.tenant == try(sgt.device.tenant, tenant.name)]) > 0 ? [for device in local.l4l7_devices : try(device.copy_device, local.defaults.apic.tenants.services.l4l7_devices.copy_device) if device.name == sgt.device.name && (device.tenant == try(sgt.device.tenant, tenant.name))][0] : false) == true ? try(sgt.device.node_name, "CP1") : try(sgt.device.node_name, "N1")
        device_adjacency_type   = try(sgt.device.adjacency_type, local.defaults.apic.tenants.services.service_graph_templates.device.adjacency_type)
        consumer_direct_connect = try(sgt.consumer.direct_connect, local.defaults.apic.tenants.services.service_graph_templates.consumer.direct_connect)
        provider_direct_connect = try(sgt.provider.direct_connect, local.defaults.apic.tenants.services.service_graph_templates.provider.direct_connect)
      }
    ]
  ])
}

module "aci_service_graph_template" {
  source = "./modules/terraform-aci-service-graph-template"

  for_each                = { for sg_template in local.service_graph_templates : sg_template.key => sg_template if local.modules.aci_service_graph_template && var.manage_tenants }
  tenant                  = each.value.tenant
  name                    = each.value.name
  annotation              = each.value.annotation
  description             = each.value.description
  alias                   = each.value.alias
  template_type           = each.value.template_type
  redirect                = each.value.redirect
  share_encapsulation     = each.value.share_encapsulation
  device_name             = each.value.device_name
  device_tenant           = each.value.device_tenant
  device_function         = each.value.device_function
  device_copy             = each.value.device_copy
  device_managed          = each.value.device_managed
  device_node_name        = each.value.device_node_name
  device_adjacency_type   = each.value.device_adjacency_type
  consumer_direct_connect = each.value.consumer_direct_connect
  provider_direct_connect = each.value.provider_direct_connect

  depends_on = [
    module.aci_tenant,
    module.aci_l4l7_device,
  ]
}

locals {
  device_selection_policies = flatten([
    for tenant in local.tenants : [
      for dsp in try(tenant.services.device_selection_policies, []) : {
        key                                                     = format("%s/%s-%s", tenant.name, dsp.contract, dsp.service_graph_template)
        tenant                                                  = tenant.name
        contract                                                = "${dsp.contract}${local.defaults.apic.tenants.contracts.name_suffix}"
        service_graph_template                                  = "${dsp.service_graph_template}${local.defaults.apic.tenants.services.service_graph_templates.name_suffix}"
        sgt_device_tenant                                       = length(try(tenant.services.service_graph_templates, [])) != 0 ? [for sg_template in try(tenant.services.service_graph_templates, []) : try(sg_template.device.tenant, tenant.name) if sg_template.name == dsp.service_graph_template][0] : tenant.name
        sgt_device_name                                         = try("${dsp.device_name}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}", length(try(tenant.services.service_graph_templates, [])) != 0 ? [for sg_template in try(tenant.services.service_graph_templates, []) : "${sg_template.device.name}${local.defaults.apic.tenants.services.l4l7_devices.name_suffix}" if sg_template.name == dsp.service_graph_template][0] : "")
        node_name                                               = try(dsp.node_name, "N1")
        consumer_l3_destination                                 = try(dsp.consumer.l3_destination, local.defaults.apic.tenants.services.device_selection_policies.consumer.l3_destination)
        consumer_permit_logging                                 = try(dsp.consumer.permit_logging, local.defaults.apic.tenants.services.device_selection_policies.consumer.permit_logging)
        consumer_logical_interface                              = try("${dsp.consumer.logical_interface}${local.defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix}", "")
        consumer_redirect_policy                                = try("${dsp.consumer.redirect_policy.name}${local.defaults.apic.tenants.services.redirect_policies.name_suffix}", "")
        consumer_redirect_policy_tenant                         = try(dsp.consumer.redirect_policy.tenant, tenant.name)
        consumer_bridge_domain                                  = try("${dsp.consumer.bridge_domain.name}${local.defaults.apic.tenants.bridge_domains.name_suffix}", "")
        consumer_bridge_domain_tenant                           = try(dsp.consumer.bridge_domain.tenant, tenant.name)
        consumer_external_endpoint_group                        = try("${dsp.consumer.external_endpoint_group.name}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
        consumer_external_endpoint_group_l3out                  = try("${dsp.consumer.external_endpoint_group.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
        consumer_external_endpoint_group_tenant                 = try(dsp.consumer.external_endpoint_group.tenant, tenant.name)
        consumer_external_endpoint_group_redistribute_bgp       = try(dsp.consumer.external_endpoint_group.redistribute.bgp, local.defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.bgp)
        consumer_external_endpoint_group_redistribute_ospf      = try(dsp.consumer.external_endpoint_group.redistribute.ospf, local.defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.ospf)
        consumer_external_endpoint_group_redistribute_connected = try(dsp.consumer.external_endpoint_group.redistribute.connected, local.defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.connected)
        consumer_external_endpoint_group_redistribute_static    = try(dsp.consumer.external_endpoint_group.redistribute.static, local.defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.static)
        consumer_service_epg_policy                             = try("${dsp.consumer.service_epg_policy}${local.defaults.apic.tenants.services.service_epg_policies.name_suffix}", "")
        consumer_service_epg_policy_tenant                      = tenant.name
        consumer_custom_qos_policy                              = try("${dsp.consumer.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
        provider_l3_destination                                 = try(dsp.provider.l3_destination, local.defaults.apic.tenants.services.device_selection_policies.provider.l3_destination)
        provider_permit_logging                                 = try(dsp.provider.permit_logging, local.defaults.apic.tenants.services.device_selection_policies.provider.permit_logging)
        provider_logical_interface                              = try("${dsp.provider.logical_interface}${local.defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix}", "")
        provider_redirect_policy                                = try("${dsp.provider.redirect_policy.name}${local.defaults.apic.tenants.services.redirect_policies.name_suffix}", "")
        provider_redirect_policy_tenant                         = try(dsp.provider.redirect_policy.tenant, tenant.name)
        provider_bridge_domain                                  = try("${dsp.provider.bridge_domain.name}${local.defaults.apic.tenants.bridge_domains.name_suffix}", "")
        provider_bridge_domain_tenant                           = try(dsp.provider.bridge_domain.tenant, tenant.name)
        provider_external_endpoint_group                        = try("${dsp.provider.external_endpoint_group.name}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
        provider_external_endpoint_group_l3out                  = try("${dsp.provider.external_endpoint_group.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
        provider_external_endpoint_group_tenant                 = try(dsp.provider.external_endpoint_group.tenant, tenant.name)
        provider_external_endpoint_group_redistribute_bgp       = try(dsp.provider.external_endpoint_group.redistribute.bgp, local.defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.bgp)
        provider_external_endpoint_group_redistribute_ospf      = try(dsp.provider.external_endpoint_group.redistribute.ospf, local.defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.ospf)
        provider_external_endpoint_group_redistribute_connected = try(dsp.provider.external_endpoint_group.redistribute.connected, local.defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.connected)
        provider_external_endpoint_group_redistribute_static    = try(dsp.provider.external_endpoint_group.redistribute.static, local.defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.static)
        provider_service_epg_policy                             = try("${dsp.provider.service_epg_policy}${local.defaults.apic.tenants.services.service_epg_policies.name_suffix}", "")
        provider_service_epg_policy_tenant                      = tenant.name
        provider_custom_qos_policy                              = try("${dsp.provider.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
        copy_l3_destination                                     = try(dsp.copy_service.l3_destination, local.defaults.apic.tenants.services.device_selection_policies.copy_service.l3_destination)
        copy_permit_logging                                     = try(dsp.copy_service.permit_logging, local.defaults.apic.tenants.services.device_selection_policies.copy_service.permit_logging)
        copy_logical_interface                                  = try("${dsp.copy_service.logical_interface}${local.defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix}", "")
        copy_custom_qos_policy                                  = try("${dsp.copy_service.custom_qos_policy}${local.defaults.apic.tenants.policies.custom_qos.name_suffix}", "")
        copy_service_epg_policy                                 = try("${dsp.copy_service.service_epg_policy}${local.defaults.apic.tenants.services.service_epg_policies.name_suffix}", "")
        copy_service_epg_policy_tenant                          = tenant.name
      }
    ]
  ])
}

module "aci_device_selection_policy" {
  source = "./modules/terraform-aci-device-selection-policy"

  for_each                                                = { for pol in local.device_selection_policies : pol.key => pol if local.modules.aci_device_selection_policy && var.manage_tenants }
  tenant                                                  = each.value.tenant
  contract                                                = each.value.contract
  service_graph_template                                  = each.value.service_graph_template
  sgt_device_tenant                                       = each.value.sgt_device_tenant
  sgt_device_name                                         = each.value.sgt_device_name
  node_name                                               = each.value.node_name
  consumer_l3_destination                                 = each.value.consumer_l3_destination
  consumer_permit_logging                                 = each.value.consumer_permit_logging
  consumer_logical_interface                              = each.value.consumer_logical_interface
  consumer_redirect_policy                                = each.value.consumer_redirect_policy
  consumer_redirect_policy_tenant                         = each.value.consumer_redirect_policy_tenant
  consumer_bridge_domain                                  = each.value.consumer_bridge_domain
  consumer_bridge_domain_tenant                           = each.value.consumer_bridge_domain_tenant
  consumer_external_endpoint_group                        = each.value.consumer_external_endpoint_group
  consumer_external_endpoint_group_l3out                  = each.value.consumer_external_endpoint_group_l3out
  consumer_external_endpoint_group_tenant                 = each.value.consumer_external_endpoint_group_tenant
  consumer_external_endpoint_group_redistribute_bgp       = each.value.consumer_external_endpoint_group_redistribute_bgp
  consumer_external_endpoint_group_redistribute_ospf      = each.value.consumer_external_endpoint_group_redistribute_ospf
  consumer_external_endpoint_group_redistribute_connected = each.value.consumer_external_endpoint_group_redistribute_connected
  consumer_external_endpoint_group_redistribute_static    = each.value.consumer_external_endpoint_group_redistribute_static
  consumer_service_epg_policy                             = each.value.consumer_service_epg_policy
  consumer_service_epg_policy_tenant                      = each.value.consumer_service_epg_policy_tenant
  consumer_custom_qos_policy                              = each.value.consumer_custom_qos_policy
  provider_l3_destination                                 = each.value.provider_l3_destination
  provider_permit_logging                                 = each.value.provider_permit_logging
  provider_logical_interface                              = each.value.provider_logical_interface
  provider_redirect_policy                                = each.value.provider_redirect_policy
  provider_redirect_policy_tenant                         = each.value.provider_redirect_policy_tenant
  provider_bridge_domain                                  = each.value.provider_bridge_domain
  provider_bridge_domain_tenant                           = each.value.provider_bridge_domain_tenant
  provider_external_endpoint_group                        = each.value.provider_external_endpoint_group
  provider_external_endpoint_group_l3out                  = each.value.provider_external_endpoint_group_l3out
  provider_external_endpoint_group_tenant                 = each.value.provider_external_endpoint_group_tenant
  provider_external_endpoint_group_redistribute_bgp       = each.value.provider_external_endpoint_group_redistribute_bgp
  provider_external_endpoint_group_redistribute_ospf      = each.value.provider_external_endpoint_group_redistribute_ospf
  provider_external_endpoint_group_redistribute_connected = each.value.provider_external_endpoint_group_redistribute_connected
  provider_external_endpoint_group_redistribute_static    = each.value.provider_external_endpoint_group_redistribute_static
  provider_service_epg_policy                             = each.value.provider_service_epg_policy
  provider_service_epg_policy_tenant                      = each.value.provider_service_epg_policy_tenant
  provider_custom_qos_policy                              = each.value.provider_custom_qos_policy
  copy_l3_destination                                     = each.value.copy_l3_destination
  copy_permit_logging                                     = each.value.copy_permit_logging
  copy_logical_interface                                  = each.value.copy_logical_interface
  copy_custom_qos_policy                                  = each.value.copy_custom_qos_policy
  copy_service_epg_policy                                 = each.value.copy_service_epg_policy
  copy_service_epg_policy_tenant                          = each.value.copy_service_epg_policy_tenant

  depends_on = [
    module.aci_tenant,
    module.aci_l4l7_device,
    module.aci_service_graph_template,
    module.aci_redirect_policy,
    module.aci_contract,
    module.aci_bridge_domain,
    module.aci_external_endpoint_group,
  ]
}

locals {
  service_epg_policies = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.services.service_epg_policies, []) : {
        key             = format("%s/%s", tenant.name, policy.name)
        tenant          = tenant.name
        name            = "${policy.name}${local.defaults.apic.tenants.services.service_epg_policies.name_suffix}"
        description     = try(policy.description, "")
        preferred_group = try(policy.preferred_group, local.defaults.apic.tenants.services.service_epg_policies.preferred_group)
      }
    ]
  ])
}

module "aci_service_epg_policy" {
  source = "./modules/terraform-aci-service-epg-policy"

  for_each        = { for pol in local.service_epg_policies : pol.key => pol if local.modules.aci_service_epg_policy && var.manage_tenants }
  tenant          = each.value.tenant
  name            = each.value.name
  description     = each.value.description
  preferred_group = each.value.preferred_group

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  tenant_span_destination_groups = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.span.destination_groups, []) : {
        key                             = format("%s/%s", tenant.name, policy.name)
        tenant                          = tenant.name
        name                            = "${policy.name}${local.defaults.apic.tenants.policies.span.destination_groups.name_suffix}"
        description                     = try(policy.description, "")
        destination_tenant              = try(policy.tenant, "")
        destination_application_profile = policy.application_profile
        destination_endpoint_group      = policy.endpoint_group
        ip                              = policy.ip
        source_prefix                   = policy.source_prefix
        dscp                            = try(policy.dscp, local.defaults.apic.tenants.policies.span.destination_groups.dscp)
        flow_id                         = try(policy.flow_id, local.defaults.apic.tenants.policies.span.destination_groups.flow_id)
        mtu                             = try(policy.mtu, local.defaults.apic.tenants.policies.span.destination_groups.mtu)
        ttl                             = try(policy.ttl, local.defaults.apic.tenants.policies.span.destination_groups.ttl)
        span_version                    = try(policy.version, local.defaults.apic.tenants.policies.span.destination_groups.version)
        enforce_version                 = try(policy.enforce_version, local.defaults.apic.tenants.policies.span.destination_groups.enforce_version)
      }
    ]
  ])
}

module "aci_tenant_span_destination_group" {
  source = "./modules/terraform-aci-tenant-span-destination-group"

  for_each                        = { for span in local.tenant_span_destination_groups : span.key => span if local.modules.aci_tenant_span_destination_group && var.manage_tenants }
  tenant                          = each.value.tenant
  name                            = each.value.name
  description                     = each.value.description
  destination_tenant              = each.value.destination_tenant
  destination_application_profile = each.value.destination_application_profile
  destination_endpoint_group      = each.value.destination_endpoint_group
  ip                              = each.value.ip
  source_prefix                   = each.value.source_prefix
  dscp                            = each.value.dscp
  flow_id                         = each.value.flow_id
  mtu                             = each.value.mtu
  ttl                             = each.value.ttl
  span_version                    = each.value.span_version
  enforce_version                 = each.value.enforce_version

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  tenant_span_source_groups = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.span.source_groups, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.span.source_groups.name_suffix}"
        description = try(policy.description, "")
        admin_state = try(policy.admin_state, local.defaults.apic.tenants.policies.span.source_groups.admin_state)
        destination = policy.destination
        sources = [for s in try(policy.sources, []) : {
          name                = s.name
          description         = try(s.description, "")
          direction           = try(s.direction, local.defaults.apic.tenants.policies.span.source_groups.sources.direction)
          application_profile = try(s.application_profile, null)
          endpoint_group      = try(s.endpoint_group, null)
        }]
      }
    ]
  ])
}

module "aci_tenant_span_source_group" {
  source = "./modules/terraform-aci-tenant-span-source-group"

  for_each    = { for span in local.tenant_span_source_groups : span.key => span if local.modules.aci_tenant_span_source_group && var.manage_tenants }
  tenant      = each.value.tenant
  name        = each.value.name
  description = each.value.description
  admin_state = each.value.admin_state
  destination = each.value.destination
  sources     = each.value.sources

  depends_on = [
    module.aci_tenant,
  ]
}

locals {
  track_lists_raw = flatten([
    for tenant in local.tenants : concat(
      [
        for policy in try(tenant.policies.track_lists, []) : {
          key             = format("%s/%s", tenant.name, policy.name)
          tenant          = tenant.name
          name            = "${policy.name}${local.defaults.apic.tenants.policies.track_lists.name_suffix}"
          description     = try(policy.description, "")
          type            = try(policy.type, local.defaults.apic.tenants.policies.track_lists.type)
          percentage_up   = try(policy.percentage_up, local.defaults.apic.tenants.policies.track_lists.percentage_up)
          percentage_down = try(policy.percentage_down, local.defaults.apic.tenants.policies.track_lists.percentage_down)
          weight_up       = try(policy.weight_up, local.defaults.apic.tenants.policies.track_lists.weight_up)
          weight_down     = try(policy.weight_down, local.defaults.apic.tenants.policies.track_lists.weight_down)
          track_members   = [for tm in try(policy.track_members, []) : "${tm}${local.defaults.apic.tenants.policies.track_members.name_suffix}"]
        }
      ],
      [
        for l3out in try(tenant.l3outs, []) : concat(
          [
            for np in try(l3out.node_profiles, []) : [
              for node in try(np.nodes, []) : [
                for static_route in try(node.static_routes, []) : [
                  for next_hop in try(static_route.next_hops, []) : {
                    key             = format("%s/%s_%s", tenant.name, "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", next_hop.ip)
                    tenant          = tenant.name
                    name            = try("${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}", null)
                    description     = try("Generated by l3out: ${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}, node: ${node.node_id}", "")
                    type            = try(local.defaults.apic.tenants.policies.track_lists.type)
                    percentage_up   = try(local.defaults.apic.tenants.policies.track_lists.percentage_up)
                    percentage_down = try(local.defaults.apic.tenants.policies.track_lists.percentage_down)
                    weight_up       = try(local.defaults.apic.tenants.policies.track_lists.weight_up)
                    weight_down     = try(local.defaults.apic.tenants.policies.track_lists.weight_down)
                    track_members   = try(["${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}"], [])
                  } if try(next_hop.ip_sla_policy, null) != null
                ]
              ]
            ]
          ],
          [
            for node in try(l3out.nodes, []) : [
              for static_route in try(node.static_routes, []) : [
                for next_hop in try(static_route.next_hops, []) : {
                  key             = format("%s/%s_%s", tenant.name, "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", next_hop.ip)
                  tenant          = tenant.name
                  name            = try("${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}", null)
                  description     = try("Generated by l3out: ${l3out.name}, node: ${node.node_id}", "")
                  type            = try(local.defaults.apic.tenants.policies.track_lists.type)
                  percentage_up   = try(local.defaults.apic.tenants.policies.track_lists.percentage_up)
                  percentage_down = try(local.defaults.apic.tenants.policies.track_lists.percentage_down)
                  weight_up       = try(local.defaults.apic.tenants.policies.track_lists.weight_up)
                  weight_down     = try(local.defaults.apic.tenants.policies.track_lists.weight_down)
                  track_members   = try(["${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}"], [])
                } if try(next_hop.ip_sla_policy, null) != null
              ]
            ]
          ]
        )
      ]
    )
  ])

  track_lists_grouped = {
    for track_list in local.track_lists_raw :
    track_list.key => track_list...
  }

  track_lists = [
    for track_list in local.track_lists_grouped : track_list[0]
  ]
}

module "aci_track_list" {
  source = "./modules/terraform-aci-track-list"

  for_each        = { for track_list in local.track_lists : track_list.key => track_list if local.modules.aci_track_list && var.manage_tenants }
  tenant          = each.value.tenant
  name            = each.value.name
  description     = each.value.description
  type            = each.value.type
  percentage_up   = each.value.percentage_up
  percentage_down = each.value.percentage_down
  weight_up       = each.value.weight_up
  weight_down     = each.value.weight_down
  track_members   = each.value.track_members

  depends_on = [
    module.aci_tenant,
    module.aci_track_member,
  ]
}

locals {
  track_members_raw = flatten([
    for tenant in local.tenants : concat(
      [
        for policy in try(tenant.policies.track_members, []) : {
          key                  = format("%s/%s", tenant.name, policy.name)
          tenant               = tenant.name
          name                 = "${policy.name}${local.defaults.apic.tenants.policies.track_members.name_suffix}"
          description          = try(policy.description, "")
          destination_ip       = policy.destination_ip
          scope_type           = policy.scope_type
          scope                = policy.scope
          ip_sla_policy        = policy.ip_sla_policy
          ip_sla_policy_tenant = !contains(try(local.tenant_shared_policies[tenant.name].ip_sla_policies, []), policy.ip_sla_policy) && contains(try(local.tenant_shared_policies["common"].ip_sla_policies, []), policy.ip_sla_policy) ? "common" : tenant.name
        }
      ],
      [
        for l3out in try(tenant.l3outs, []) : concat(
          [
            for np in try(l3out.node_profiles, []) : [
              for node in try(np.nodes, []) : [
                for static_route in try(node.static_routes, []) : [
                  for next_hop in try(static_route.next_hops, []) : {
                    key                  = format("%s/%s_%s", tenant.name, "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", next_hop.ip)
                    tenant               = tenant.name
                    name                 = try("${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}", null)
                    description          = try("Generated by l3out: ${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}, node: ${node.node_id}", "")
                    destination_ip       = try(next_hop.ip, null)
                    scope_type           = "l3out"
                    scope                = try("${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
                    ip_sla_policy        = try("${next_hop.ip_sla_policy}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}", null)
                    ip_sla_policy_tenant = !contains(try(local.tenant_shared_policies[tenant.name].ip_sla_policies, []), next_hop.ip_sla_policy) && contains(try(local.tenant_shared_policies["common"].ip_sla_policies, []), next_hop.ip_sla_policy) ? "common" : tenant.name
                  } if try(next_hop.ip_sla_policy, null) != null
                ]
              ]
            ]
          ],
          [
            for node in try(l3out.nodes, []) : [
              for static_route in try(node.static_routes, []) : [
                for next_hop in try(static_route.next_hops, []) : {
                  key                  = format("%s/%s_%s", tenant.name, "${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", next_hop.ip)
                  tenant               = tenant.name
                  name                 = try("${l3out.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}_${next_hop.ip}", null)
                  description          = try("Generated by l3out: ${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}, node: ${node.node_id}", "")
                  destination_ip       = try(next_hop.ip, null)
                  scope_type           = "l3out"
                  scope                = try("${l3out.name}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
                  ip_sla_policy        = try("${next_hop.ip_sla_policy}${local.defaults.apic.tenants.policies.ip_sla_policies.name_suffix}", null)
                  ip_sla_policy_tenant = !contains(try(local.tenant_shared_policies[tenant.name].ip_sla_policies, []), next_hop.ip_sla_policy) && contains(try(local.tenant_shared_policies["common"].ip_sla_policies, []), next_hop.ip_sla_policy) ? "common" : tenant.name
                } if try(next_hop.ip_sla_policy, null) != null
              ]
            ]
          ]
      )],
    )
  ])

  track_members_grouped = {
    for track_member in local.track_members_raw :
    track_member.key => track_member...
  }

  track_members = [
    for track_member in local.track_members_grouped : track_member[0]
  ]
}

module "aci_track_member" {
  source = "./modules/terraform-aci-track-member"

  for_each             = { for member in local.track_members : member.key => member if local.modules.aci_track_member && var.manage_tenants }
  tenant               = each.value.tenant
  name                 = each.value.name
  description          = each.value.description
  destination_ip       = each.value.destination_ip
  scope_type           = each.value.scope_type
  scope                = each.value.scope
  ip_sla_policy        = each.value.ip_sla_policy
  ip_sla_policy_tenant = each.value.ip_sla_policy_tenant

  depends_on = [
    module.aci_tenant,
    module.aci_ip_sla_policy,
    module.aci_l3out,
    module.aci_bridge_domain
  ]
}

locals {
  ep_mac_tags = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.endpoint_mac_tags, []) : {
        key           = format("%s/%s/%s", tenant.name, policy.mac, try(policy.bridge_domain, local.defaults.apic.tenants.policies.endpoint_mac_tags.bridge_domain))
        tenant        = tenant.name
        mac           = upper(policy.mac)
        bridge_domain = try("${policy.bridge_domain}${local.defaults.apic.tenants.bridge_domains.name_suffix}", local.defaults.apic.tenants.policies.endpoint_mac_tags.bridge_domain)
        vrf           = try(policy.bridge_domain, local.defaults.apic.tenants.policies.endpoint_mac_tags.bridge_domain) == "all" ? "${policy.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}" : null
        tags          = try(policy.tags, [])
      }
    ]
  ])
}

module "aci_endpoint_mac_tag_policy" {
  source = "./modules/terraform-aci-endpoint-mac-tag-policy"

  for_each      = { for pol in local.ep_mac_tags : pol.key => pol if local.modules.aci_endpoint_mac_tag_policy && var.manage_tenants }
  tenant        = each.value.tenant
  mac           = each.value.mac
  bridge_domain = each.value.bridge_domain
  vrf           = try(each.value.vrf, null)
  tags          = each.value.tags

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
    module.aci_bridge_domain,
  ]
}

locals {
  ep_ip_tags = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.endpoint_ip_tags, []) : {
        key    = format("%s/%s/%s", tenant.name, policy.vrf, policy.ip)
        ip     = policy.ip
        tenant = tenant.name
        vrf    = "${policy.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}"
        tags   = try(policy.tags, [])
      }
    ]
  ])
}

module "aci_endpoint_ip_tag_policy" {
  source = "./modules/terraform-aci-endpoint-ip-tag-policy"

  for_each = { for pol in local.ep_ip_tags : pol.key => pol if local.modules.aci_endpoint_ip_tag_policy && var.manage_tenants }
  ip       = each.value.ip
  tenant   = each.value.tenant
  vrf      = each.value.vrf
  tags     = each.value.tags

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
  ]
}

locals {
  tenant_monitoring_policy = flatten([
    for tenant in local.tenants : [
      for policy in try(tenant.policies.monitoring.policies, []) : {
        key         = format("%s/%s", tenant.name, policy.name)
        tenant      = tenant.name
        name        = "${policy.name}${local.defaults.apic.tenants.policies.monitoring.policies.name_suffix}"
        description = try(policy.description, "")
        snmp_trap_policies = [for snmp_policy in try(policy.snmp_traps, []) : {
          name              = "${snmp_policy.name}${local.defaults.apic.tenants.policies.monitoring.policies.snmp_traps.name_suffix}"
          destination_group = try("${snmp_policy.destination_group}${local.defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix}", null)
        }]
        syslog_policies = [for syslog_policy in try(policy.syslogs, []) : {
          name              = "${syslog_policy.name}${local.defaults.apic.tenants.policies.monitoring.policies.syslogs.name_suffix}"
          audit             = try(syslog_policy.audit, local.defaults.apic.tenants.policies.monitoring.policies.syslogs.audit)
          events            = try(syslog_policy.events, local.defaults.apic.tenants.policies.monitoring.policies.syslogs.events)
          faults            = try(syslog_policy.faults, local.defaults.apic.tenants.policies.monitoring.policies.syslogs.faults)
          session           = try(syslog_policy.session, local.defaults.apic.tenants.policies.monitoring.policies.syslogs.session)
          minimum_severity  = try(syslog_policy.minimum_severity, local.defaults.apic.tenants.policies.monitoring.policies.syslogs.minimum_severity)
          destination_group = try("${syslog_policy.destination_group}${local.defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}", null)
        }]
        fault_severity_policies = [for policy in try(policy.fault_severity_policies, []) : {
          class = policy.class
          faults = [for fault in try(policy.faults, []) : {
            fault_id         = fault.fault_id
            initial_severity = try(fault.initial_severity, local.defaults.apic.tenants.policies.monitoring.policies.fault_severity_policies.initial_severity)
            target_severity  = try(fault.target_severity, local.defaults.apic.tenants.policies.monitoring.policies.fault_severity_policies.target_severity)
            description      = try(fault.description, "")
          }]
        }]
      }
    ]
  ])
}

module "aci_tenant_monitoring_policy" {
  source   = "./modules/terraform-aci-tenant-monitoring-policy"
  for_each = { for pol in local.tenant_monitoring_policy : pol.key => pol if local.modules.aci_tenant_monitoring_policy && var.manage_tenants }

  name                    = each.value.name
  description             = each.value.description
  tenant                  = each.value.tenant
  snmp_trap_policies      = each.value.snmp_trap_policies
  syslog_policies         = each.value.syslog_policies
  fault_severity_policies = each.value.fault_severity_policies

  depends_on = [
    module.aci_snmp_trap_policy,
    module.aci_syslog_policy,
    module.aci_tenant,
  ]
}

locals {
  netflow_exporters = flatten([
    for tenant in local.tenants : [
      for exporter in try(tenant.policies.netflow_exporters, []) : {
        key              = format("%s/%s/%s", tenant.name, exporter.name, try(exporter.vrf, "novrf"))
        name             = "${exporter.name}${local.defaults.apic.tenants.policies.netflow_exporters.name_suffix}"
        description      = try(exporter.description, "")
        destination_port = exporter.destination_port
        destination_ip   = exporter.destination_ip
        dscp             = try(exporter.dscp, local.defaults.apic.tenants.policies.netflow_exporters.dscp)
        source_type      = try(exporter.source_type, local.defaults.apic.tenants.policies.netflow_exporters.source_type)
        source_ip        = try(exporter.source_ip, local.defaults.apic.tenants.policies.netflow_exporters.source_ip)

        epg_type                = try(exporter.epg_type, "")
        tenant                  = tenant.name
        application_profile     = try("${exporter.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}", "")
        endpoint_group          = try("${exporter.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}", "")
        vrf                     = try("${exporter.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", "")
        l3out                   = try("${exporter.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
        external_endpoint_group = try("${exporter.external_endpoint_group}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
      }
    ]
  ])
}

module "aci_tenant_netflow_exporter" {
  source = "./modules/terraform-aci-tenant-netflow-exporter"

  for_each                = { for pol in local.netflow_exporters : pol.key => pol if local.modules.aci_tenant_netflow_exporter && var.manage_tenants }
  name                    = each.value.name
  description             = each.value.description
  destination_port        = each.value.destination_port
  destination_ip          = each.value.destination_ip
  dscp                    = each.value.dscp
  source_type             = each.value.source_type
  source_ip               = each.value.source_ip
  epg_type                = each.value.epg_type
  tenant                  = each.value.tenant
  application_profile     = each.value.application_profile
  endpoint_group          = each.value.endpoint_group
  vrf                     = each.value.vrf
  l3out                   = each.value.l3out
  external_endpoint_group = each.value.external_endpoint_group

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
  ]
}

locals {
  netflow_monitors = flatten([
    for tenant in local.tenants : [
      for monitor in try(tenant.policies.netflow_monitors, []) : {
        key            = format("%s/%s", tenant.name, monitor.name)
        name           = "${monitor.name}${local.defaults.apic.tenants.policies.netflow_monitors.name_suffix}"
        description    = try(monitor.description, "")
        flow_record    = try(monitor.flow_record, "")
        flow_exporters = try(monitor.flow_exporters, [])
        tenant         = tenant.name
      }
    ]
  ])
}

module "aci_tenant_netflow_monitor" {
  source = "./modules/terraform-aci-tenant-netflow-monitor"

  for_each       = { for pol in local.netflow_monitors : pol.key => pol if local.modules.aci_tenant_netflow_monitor && var.manage_tenants }
  tenant         = each.value.tenant
  name           = each.value.name
  description    = each.value.description
  flow_record    = each.value.flow_record
  flow_exporters = each.value.flow_exporters

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
    module.aci_tenant_netflow_exporter,
    module.aci_tenant_netflow_record,
  ]
}

locals {
  netflow_records = flatten([
    for tenant in local.tenants : [
      for record in try(tenant.policies.netflow_records, []) : {
        key              = format("%s/%s", tenant.name, record.name)
        name             = "${record.name}${local.defaults.apic.tenants.policies.netflow_records.name_suffix}"
        description      = try(record.description, "")
        match_parameters = try(record.match_parameters, [])
        tenant           = tenant.name
      }
    ]
  ])
}

module "aci_tenant_netflow_record" {
  source = "./modules/terraform-aci-tenant-netflow-record"

  for_each         = { for pol in local.netflow_records : pol.key => pol if local.modules.aci_tenant_netflow_record && var.manage_tenants }
  name             = each.value.name
  description      = each.value.description
  match_parameters = each.value.match_parameters
  tenant           = each.value.tenant

  depends_on = [
    module.aci_tenant,
    module.aci_vrf,
  ]
}
