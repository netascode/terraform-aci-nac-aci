module "aci_config_passphrase" {
  source  = "netascode/config-passphrase/aci"
  version = "0.1.1"

  count             = try(local.fabric_policies.config_passphrase, null) != null && local.modules.aci_config_passphrase == true && var.manage_fabric_policies ? 1 : 0
  config_passphrase = local.fabric_policies.config_passphrase
}

module "aci_apic_connectivity_preference" {
  source  = "netascode/apic-connectivity-preference/aci"
  version = "0.1.0"

  count                = local.modules.aci_apic_connectivity_preference == true && var.manage_fabric_policies ? 1 : 0
  interface_preference = try(local.fabric_policies.apic_conn_pref, local.defaults.apic.fabric_policies.apic_conn_pref)
}

module "aci_banner" {
  source  = "netascode/banner/aci"
  version = "0.1.1"

  count                   = local.modules.aci_banner == true && var.manage_fabric_policies ? 1 : 0
  apic_gui_banner_message = try(local.fabric_policies.banners.apic_gui_banner_message, "")
  apic_gui_banner_url     = try(local.fabric_policies.banners.apic_gui_banner_url, "")
  apic_gui_alias          = try(local.fabric_policies.banners.apic_gui_alias, "")
  apic_cli_banner         = try(local.fabric_policies.banners.apic_cli_banner, "")
  switch_cli_banner       = try(local.fabric_policies.banners.switch_cli_banner, "")
}

module "aci_endpoint_loop_protection" {
  source  = "netascode/endpoint-loop-protection/aci"
  version = "0.1.0"

  count                = local.modules.aci_endpoint_loop_protection == true && var.manage_fabric_policies ? 1 : 0
  action               = try(local.fabric_policies.ep_loop_protection.action, local.defaults.apic.fabric_policies.ep_loop_protection.action)
  admin_state          = try(local.fabric_policies.ep_loop_protection.admin_state, local.defaults.apic.fabric_policies.ep_loop_protection.admin_state)
  detection_interval   = try(local.fabric_policies.ep_loop_protection.detection_interval, local.defaults.apic.fabric_policies.ep_loop_protection.detection_interval)
  detection_multiplier = try(local.fabric_policies.ep_loop_protection.detection_multiplier, local.defaults.apic.fabric_policies.ep_loop_protection.detection_multiplier)
}

module "aci_rogue_endpoint_control" {
  source  = "netascode/rogue-endpoint-control/aci"
  version = "0.1.0"

  count                = local.modules.aci_rogue_endpoint_control == true && var.manage_fabric_policies ? 1 : 0
  admin_state          = try(local.fabric_policies.rogue_ep_control.admin_state, local.defaults.apic.fabric_policies.rogue_ep_control.admin_state)
  hold_interval        = try(local.fabric_policies.rogue_ep_control.hold_interval, local.defaults.apic.fabric_policies.rogue_ep_control.hold_interval)
  detection_interval   = try(local.fabric_policies.rogue_ep_control.detection_interval, local.defaults.apic.fabric_policies.rogue_ep_control.detection_interval)
  detection_multiplier = try(local.fabric_policies.rogue_ep_control.detection_multiplier, local.defaults.apic.fabric_policies.rogue_ep_control.detection_multiplier)
}

module "aci_fabric_wide_settings" {
  source  = "netascode/fabric-wide-settings/aci"
  version = "0.1.1"

  count                         = local.modules.aci_fabric_wide_settings == true && var.manage_fabric_policies ? 1 : 0
  domain_validation             = try(local.fabric_policies.global_settings.domain_validation, local.defaults.apic.fabric_policies.global_settings.domain_validation)
  enforce_subnet_check          = try(local.fabric_policies.global_settings.enforce_subnet_check, local.defaults.apic.fabric_policies.global_settings.enforce_subnet_check)
  opflex_authentication         = try(local.fabric_policies.global_settings.opflex_authentication, local.defaults.apic.fabric_policies.global_settings.opflex_authentication)
  disable_remote_endpoint_learn = try(local.fabric_policies.global_settings.disable_remote_endpoint_learn, local.defaults.apic.fabric_policies.global_settings.disable_remote_endpoint_learn)
  overlapping_vlan_validation   = try(local.fabric_policies.global_settings.overlapping_vlan_validation, local.defaults.apic.fabric_policies.global_settings.overlapping_vlan_validation)
  remote_leaf_direct            = try(local.fabric_policies.global_settings.remote_leaf_direct, local.defaults.apic.fabric_policies.global_settings.remote_leaf_direct)
  reallocate_gipo               = try(local.fabric_policies.global_settings.reallocate_gipo, local.defaults.apic.fabric_policies.global_settings.reallocate_gipo)
}

module "aci_port_tracking" {
  source  = "netascode/port-tracking/aci"
  version = "0.1.0"

  count       = local.modules.aci_port_tracking == true && var.manage_fabric_policies ? 1 : 0
  admin_state = try(local.fabric_policies.port_tracking.admin_state, local.defaults.apic.fabric_policies.port_tracking.admin_state)
  delay       = try(local.fabric_policies.port_tracking.delay, local.defaults.apic.fabric_policies.port_tracking.delay)
  min_links   = try(local.fabric_policies.port_tracking.min_links, local.defaults.apic.fabric_policies.port_tracking.min_links)
}

module "aci_ptp" {
  source  = "netascode/ptp/aci"
  version = "0.1.1"

  count             = local.modules.aci_ptp == true && var.manage_fabric_policies ? 1 : 0
  admin_state       = try(local.fabric_policies.ptp.admin_state, local.defaults.apic.fabric_policies.ptp.admin_state)
  global_domain     = try(local.fabric_policies.ptp.global_domain, null)
  profile           = try(local.fabric_policies.ptp.profile, null)
  announce_interval = try(local.fabric_policies.ptp.announce_interval, null)
  announce_timeout  = try(local.fabric_policies.ptp.announce_timeout, null)
  sync_interval     = try(local.fabric_policies.ptp.sync_interval, null)
  delay_interval    = try(local.fabric_policies.ptp.delay_interval, null)
}

module "aci_ip_aging" {
  source  = "netascode/ip-aging/aci"
  version = "0.1.0"

  count       = local.modules.aci_ip_aging == true && var.manage_fabric_policies ? 1 : 0
  admin_state = try(local.fabric_policies.ip_aging, local.defaults.apic.fabric_policies.ip_aging)
}

module "aci_system_global_gipo" {
  source  = "netascode/system-global-gipo/aci"
  version = "0.1.0"

  count          = local.modules.aci_system_global_gipo == true && var.manage_fabric_policies ? 1 : 0
  use_infra_gipo = try(local.fabric_policies.use_infra_gipo, local.defaults.apic.fabric_policies.use_infra_gipo)
}

module "aci_coop_policy" {
  source  = "netascode/coop-policy/aci"
  version = "0.1.0"

  count             = local.modules.aci_coop_policy == true && var.manage_fabric_policies ? 1 : 0
  coop_group_policy = try(local.fabric_policies.coop_group_policy, local.defaults.apic.fabric_policies.coop_group_policy)
}

module "aci_fabric_isis_policy" {
  source  = "netascode/fabric-isis-policy/aci"
  version = "0.1.0"

  count               = local.modules.aci_fabric_isis_policy == true && var.manage_fabric_policies ? 1 : 0
  redistribute_metric = try(local.fabric_policies.fabric_isis_redistribute_metric, local.defaults.apic.fabric_policies.fabric_isis_redistribute_metric)
}

module "aci_fabric_isis_bfd" {
  source  = "netascode/fabric-isis-bfd/aci"
  version = "0.1.0"

  count       = local.modules.aci_fabric_isis_bfd == true && var.manage_fabric_policies ? 1 : 0
  admin_state = try(local.fabric_policies.fabric_isis_bfd, local.defaults.apic.fabric_policies.fabric_isis_bfd)
}

module "aci_fabric_l2_mtu" {
  source  = "netascode/fabric-l2-mtu/aci"
  version = "0.1.0"

  count       = local.modules.aci_fabric_l2_mtu == true && var.manage_fabric_policies ? 1 : 0
  l2_port_mtu = try(local.fabric_policies.l2_port_mtu, local.defaults.apic.fabric_policies.l2_port_mtu)
}

module "aci_bgp_policy" {
  source  = "netascode/bgp-policy/aci"
  version = "0.2.0"

  count         = try(local.fabric_policies.fabric_bgp_as, null) != null && local.modules.aci_bgp_policy && var.manage_fabric_policies ? 1 : 0
  fabric_bgp_as = try(local.fabric_policies.fabric_bgp_as, null)
  fabric_bgp_rr = [for rr in try(local.fabric_policies.fabric_bgp_rr, []) : {
    node_id = rr
    pod_id  = try([for node in local.node_policies.nodes : try(node.pod, local.defaults.apic.fabric_policies.fabric_bgp_rr.pod_id) if node.id == rr][0], local.defaults.apic.node_policies.nodes.pod)
  }]
  fabric_bgp_external_rr = [for rr in try(local.fabric_policies.fabric_bgp_ext_rr, []) : {
    node_id = rr
    pod_id  = try([for node in local.node_policies.nodes : try(node.pod, local.defaults.apic.fabric_policies.fabric_bgp_ext_rr.pod_id) if node.id == rr][0], local.defaults.apic.node_policies.nodes.pod)
  }]
}

module "aci_date_time_format" {
  source  = "netascode/date-time-format/aci"
  version = "0.1.0"

  count          = local.modules.aci_date_time_format == true && var.manage_fabric_policies ? 1 : 0
  display_format = try(local.fabric_policies.date_time_format.display_format, local.defaults.apic.fabric_policies.date_time_format.display_format)
  timezone       = try(local.fabric_policies.date_time_format.timezone, local.defaults.apic.fabric_policies.date_time_format.timezone)
  show_offset    = try(local.fabric_policies.date_time_format.show_offset, local.defaults.apic.fabric_policies.date_time_format.show_offset)
}

module "aci_l2_mtu_policy" {
  source  = "netascode/l2-mtu-policy/aci"
  version = "0.1.0"

  for_each      = { for policy in try(local.fabric_policies.l2_mtu_policies, []) : policy.name => policy if local.modules.aci_l2_mtu_policy && var.manage_fabric_policies }
  name          = "${each.value.name}${local.defaults.apic.fabric_policies.l2_mtu_policies.name_suffix}"
  port_mtu_size = try(each.value.port_mtu_size, local.defaults.apic.fabric_policies.l2_mtu_policies.port_mtu_size)
}

module "aci_dns_policy" {
  source  = "netascode/dns-policy/aci"
  version = "0.2.0"

  for_each      = { for policy in try(local.fabric_policies.dns_policies, []) : policy.name => policy if local.modules.aci_dns_policy && var.manage_fabric_policies }
  name          = "${each.value.name}${local.defaults.apic.fabric_policies.dns_policies.name_suffix}"
  mgmt_epg_type = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.dns_policies.mgmt_epg)
  mgmt_epg_name = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.dns_policies.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
  providers_ = [for prov in try(each.value.providers, []) : {
    ip        = prov.ip
    preferred = try(prov.preferred, local.defaults.apic.fabric_policies.dns_policies.providers.preferred)
  }]
  domains = [for dom in try(each.value.domains, []) : {
    name    = dom.name
    default = try(dom.default, local.defaults.apic.fabric_policies.dns_policies.domains.default)
  }]
}

module "aci_error_disabled_recovery" {
  source  = "netascode/error-disabled-recovery/aci"
  version = "0.1.0"

  count      = local.modules.aci_error_disabled_recovery == true && var.manage_fabric_policies ? 1 : 0
  interval   = try(local.fabric_policies.err_disabled_recovery.interval, local.defaults.apic.fabric_policies.err_disabled_recovery.interval)
  mcp_loop   = try(local.fabric_policies.err_disabled_recovery.mcp_loop, local.defaults.apic.fabric_policies.err_disabled_recovery.mcp_loop)
  ep_move    = try(local.fabric_policies.err_disabled_recovery.ep_move, local.defaults.apic.fabric_policies.err_disabled_recovery.ep_move)
  bpdu_guard = try(local.fabric_policies.err_disabled_recovery.bpdu_guard, local.defaults.apic.fabric_policies.err_disabled_recovery.bpdu_guard)
}

module "aci_date_time_policy" {
  source  = "netascode/date-time-policy/aci"
  version = "0.2.2"

  for_each                       = { for policy in try(local.fabric_policies.pod_policies.date_time_policies, []) : policy.name => policy if local.modules.aci_date_time_policy && var.manage_fabric_policies }
  name                           = "${each.value.name}${local.defaults.apic.fabric_policies.pod_policies.date_time_policies.name_suffix}"
  apic_ntp_server_master_stratum = try(each.value.apic_ntp_server_master_stratum, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_master_stratum)
  ntp_admin_state                = try(each.value.ntp_admin_state, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_admin_state)
  ntp_auth_state                 = try(each.value.ntp_auth_state, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_auth_state)
  apic_ntp_server_master_mode    = try(each.value.apic_ntp_server_master_mode, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_master_mode)
  apic_ntp_server_state          = try(each.value.apic_ntp_server_state, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_state)
  ntp_servers = [for server in try(each.value.ntp_servers, []) : {
    hostname_ip   = server.hostname_ip
    preferred     = try(server.preferred, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.preferred)
    mgmt_epg_type = try(server.mgmt_epg, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.mgmt_epg)
    mgmt_epg_name = try(server.mgmt_epg, local.defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
    auth_key_id   = try(server.auth_key_id, null)
  }]
  ntp_keys = [for key in try(each.value.ntp_keys, []) : {
    id        = key.id
    key       = key.key
    auth_type = key.auth_type
    trusted   = key.trusted
  }]
}

module "aci_snmp_policy" {
  source  = "netascode/snmp-policy/aci"
  version = "0.2.2"

  for_each    = { for policy in try(local.fabric_policies.pod_policies.snmp_policies, []) : policy.name => policy if local.modules.aci_snmp_policy && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}"
  admin_state = try(each.value.admin_state, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.admin_state)
  location    = try(each.value.location, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.location)
  contact     = try(each.value.contact, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.contact)
  communities = try(each.value.communities, [])
  users = [for user in try(each.value.users, []) : {
    name               = user.name
    privacy_type       = try(user.privacy_type, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.users.privacy_type)
    privacy_key        = try(user.privacy_key, "")
    authorization_type = try(user.authorization_type, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.users.authorization_type)
    authorization_key  = try(user.authorization_key, "")
  }]
  trap_forwarders = [for trap in try(each.value.trap_forwarders, []) : {
    ip   = trap.ip
    port = try(trap.port, local.defaults.apic.fabric_policies.pod_policies.snmp_policies.trap_forwarders.port)
  }]
  clients = [for client in try(each.value.clients, []) : {
    name          = "${client.name}${local.defaults.apic.fabric_policies.pod_policies.snmp_policies.clients.name_suffix}"
    mgmt_epg_type = client.mgmt_epg
    mgmt_epg_name = client.mgmt_epg == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
    entries = [for entry in try(client.entries, []) : {
      ip   = entry.ip
      name = entry.name
    }]
  }]
}

module "aci_fabric_pod_policy_group" {
  source  = "netascode/fabric-pod-policy-group/aci"
  version = "0.1.1"

  for_each                 = { for pg in try(local.fabric_policies.pod_policy_groups, []) : pg.name => pg if local.modules.aci_fabric_pod_policy_group && var.manage_fabric_policies }
  name                     = "${each.value.name}${local.defaults.apic.fabric_policies.pod_policy_groups.name_suffix}"
  snmp_policy              = try("${each.value.snmp_policy}${local.defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}", "")
  date_time_policy         = try("${each.value.date_time_policy}${local.defaults.apic.fabric_policies.pod_policies.date_time_policies.name_suffix}", "")
  management_access_policy = try("${each.value.management_access_policy}${local.defaults.apic.fabric_policies.pod_policies.management_access_policies.name_suffix}", "")

  depends_on = [
    module.aci_snmp_policy,
    module.aci_date_time_policy,
    module.aci_management_access_policy,
  ]
}

module "aci_fabric_pod_profile_auto" {
  source  = "netascode/fabric-pod-profile/aci"
  version = "0.2.1"

  for_each = { for pod in try(local.pod_policies.pods, []) : pod.id => pod if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_pod_profiles, local.defaults.apic.auto_generate_pod_profiles)) && local.modules.aci_fabric_pod_profile && var.manage_fabric_policies }
  name     = replace(each.value.id, "/^(?P<id>.+)$/", replace(try(local.fabric_policies.pod_profile_name, local.defaults.apic.fabric_policies.pod_profile_name), "\\g<id>", "$${id}"))
  selectors = [{
    name         = replace(each.value.id, "/^(?P<id>.+)$/", replace(try(local.fabric_policies.pod_profile_pod_selector_name, local.defaults.apic.fabric_policies.pod_profile_pod_selector_name), "\\g<id>", "$${id}"))
    policy_group = try("${each.value.policy}${local.defaults.apic.fabric_policies.pod_policy_groups.name_suffix}", null)
    pod_blocks = [{
      name = each.value.id
      from = each.value.id
      to   = each.value.id
    }]
  }]

  depends_on = [
    module.aci_fabric_pod_policy_group,
  ]
}

module "aci_fabric_pod_profile_manual" {
  source  = "netascode/fabric-pod-profile/aci"
  version = "0.2.1"

  for_each = { for prof in try(local.fabric_policies.pod_profiles, []) : prof.name => prof if local.modules.aci_fabric_pod_profile && var.manage_fabric_policies }
  name     = "${each.value.name}${local.defaults.apic.fabric_policies.pod_profiles.name_suffix}"
  selectors = [for selector in try(each.value.selectors, []) : {
    name         = "${selector.name}${local.defaults.apic.fabric_policies.pod_profiles.selectors.name_suffix}"
    policy_group = try("${selector.policy}${local.defaults.apic.fabric_policies.pod_policy_groups.name_suffix}", null)
    type         = try(selector.type, local.defaults.apic.fabric_policies.pod_profiles.selectors.type)
    pod_blocks = [for block in try(selector.pod_blocks, []) : {
      name = "${block.name}${local.defaults.apic.fabric_policies.pod_profiles.selectors.pod_blocks.name_suffix}"
      from = block.from
      to   = try(block.to, block.from)
    }]
  }]

  depends_on = [
    module.aci_fabric_pod_policy_group,
  ]
}

module "aci_psu_policy" {
  source  = "netascode/psu-policy/aci"
  version = "0.1.0"

  for_each    = { for pol in try(local.fabric_policies.switch_policies.psu_policies, []) : pol.name => pol if local.modules.aci_psu_policy && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.switch_policies.psu_policies.name_suffix}"
  admin_state = each.value.admin_state
}

module "aci_node_control_policy" {
  source  = "netascode/node-control-policy/aci"
  version = "0.1.0"

  for_each  = { for pol in try(local.fabric_policies.switch_policies.node_control_policies, []) : pol.name => pol if local.modules.aci_node_control_policy && var.manage_fabric_policies }
  name      = "${each.value.name}${local.defaults.apic.fabric_policies.switch_policies.node_control_policies.name_suffix}"
  dom       = try(each.value.dom, local.defaults.apic.fabric_policies.switch_policies.node_control_policies.dom)
  telemetry = try(each.value.telemetry, local.defaults.apic.fabric_policies.switch_policies.node_control_policies.telemetry)
}

module "aci_fabric_leaf_switch_policy_group" {
  source  = "netascode/fabric-leaf-switch-policy-group/aci"
  version = "0.1.0"

  for_each            = { for pg in try(local.fabric_policies.leaf_switch_policy_groups, []) : pg.name => pg if local.modules.aci_fabric_leaf_switch_policy_group && var.manage_fabric_policies }
  name                = "${each.value.name}${local.defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix}"
  psu_policy          = try("${each.value.psu_policy}${local.defaults.apic.fabric_policies.switch_policies.psu_policies.name_suffix}", "")
  node_control_policy = try("${each.value.node_control_policy}${local.defaults.apic.fabric_policies.switch_policies.node_control_policies.name_suffix}", "")

  depends_on = [
    module.aci_psu_policy,
    module.aci_node_control_policy,
  ]
}

module "aci_fabric_spine_switch_policy_group" {
  source  = "netascode/fabric-spine-switch-policy-group/aci"
  version = "0.1.0"

  for_each            = { for pg in try(local.fabric_policies.spine_switch_policy_groups, []) : pg.name => pg if local.modules.aci_fabric_spine_switch_policy_group && var.manage_fabric_policies }
  name                = "${each.value.name}${local.defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix}"
  psu_policy          = try("${each.value.psu_policy}${local.defaults.apic.fabric_policies.switch_policies.psu_policies.name_suffix}", "")
  node_control_policy = try("${each.value.node_control_policy}${local.defaults.apic.fabric_policies.switch_policies.node_control_policies.name_suffix}", "")

  depends_on = [
    module.aci_psu_policy,
    module.aci_node_control_policy,
  ]
}

module "aci_fabric_leaf_switch_profile_auto" {
  source  = "netascode/fabric-leaf-switch-profile/aci"
  version = "0.2.0"

  for_each           = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "leaf" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_fabric_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_fabric_leaf_switch_interface_profiles)) && local.modules.aci_fabric_leaf_switch_profile && var.manage_fabric_policies }
  name               = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.leaf_switch_profile_name, local.defaults.apic.fabric_policies.leaf_switch_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
  interface_profiles = [replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.leaf_interface_profile_name, local.defaults.apic.fabric_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))]
  selectors = [{
    name         = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.leaf_switch_selector_name, local.defaults.apic.fabric_policies.leaf_switch_selector_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
    policy_group = try("${each.value.fabric_policy_group}${local.defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix}", null)
    node_blocks = [{
      name = each.value.id
      from = each.value.id
      to   = each.value.id
    }]
  }]

  depends_on = [
    module.aci_fabric_leaf_interface_profile_manual,
    module.aci_fabric_leaf_interface_profile_auto,
    module.aci_fabric_leaf_switch_policy_group,
  ]
}

module "aci_fabric_leaf_switch_profile_manual" {
  source  = "netascode/fabric-leaf-switch-profile/aci"
  version = "0.2.0"

  for_each = { for prof in try(local.fabric_policies.leaf_switch_profiles, []) : prof.name => prof if local.modules.aci_fabric_leaf_switch_profile && var.manage_fabric_policies }
  name     = each.value.name
  selectors = [for selector in try(each.value.selectors, []) : {
    name         = "${selector.name}${local.defaults.apic.fabric_policies.leaf_switch_profiles.selectors.name_suffix}"
    policy_group = try("${selector.policy}${local.defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix}", null)
    node_blocks = [for block in try(selector.node_blocks, []) : {
      name = "${block.name}${local.defaults.apic.fabric_policies.leaf_switch_profiles.selectors.node_blocks.name_suffix}"
      from = block.from
      to   = try(block.to, block.from)
    }]
  }]
  interface_profiles = [for profile in try(each.value.interface_profiles, []) : "${profile}${local.defaults.apic.fabric_policies.leaf_interface_profiles.name_suffix}"]

  depends_on = [
    module.aci_fabric_leaf_interface_profile_manual,
    module.aci_fabric_leaf_interface_profile_auto,
    module.aci_fabric_leaf_switch_policy_group,
  ]
}

module "aci_fabric_spine_switch_profile_auto" {
  source  = "netascode/fabric-spine-switch-profile/aci"
  version = "0.2.0"

  for_each           = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "spine" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_fabric_spine_switch_interface_profiles, local.defaults.apic.auto_generate_fabric_spine_switch_interface_profiles)) && local.modules.aci_fabric_spine_switch_profile && var.manage_fabric_policies }
  name               = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.spine_switch_profile_name, local.defaults.apic.fabric_policies.spine_switch_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
  interface_profiles = [replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.spine_interface_profile_name, local.defaults.apic.fabric_policies.spine_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))]
  selectors = [{
    name         = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.spine_switch_selector_name, local.defaults.apic.fabric_policies.spine_switch_selector_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
    policy_group = try("${each.value.fabric_policy_group}${local.defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix}", null)
    node_blocks = [{
      name = each.value.id
      from = each.value.id
      to   = each.value.id
    }]
  }]

  depends_on = [
    module.aci_fabric_spine_interface_profile_manual,
    module.aci_fabric_spine_interface_profile_auto,
    module.aci_fabric_spine_switch_policy_group,
  ]
}

module "aci_fabric_spine_switch_profile_manual" {
  source  = "netascode/fabric-spine-switch-profile/aci"
  version = "0.2.0"

  for_each = { for prof in try(local.fabric_policies.spine_switch_profiles, []) : prof.name => prof if local.modules.aci_fabric_spine_switch_profile && var.manage_fabric_policies }
  name     = each.value.name
  selectors = [for selector in try(each.value.selectors, []) : {
    name         = "${selector.name}${local.defaults.apic.fabric_policies.spine_switch_profiles.selectors.name_suffix}"
    policy_group = try("${selector.policy}${local.defaults.apic.fabric_policies.spine_switch_policy_groups.name_suffix}", null)
    node_blocks = [for block in try(selector.node_blocks, []) : {
      name = "${block.name}${local.defaults.apic.fabric_policies.spine_switch_profiles.selectors.node_blocks.name_suffix}"
      from = block.from
      to   = try(block.to, block.from)
    }]
  }]
  interface_profiles = [for profile in try(each.value.interface_profiles, []) : "${profile}${local.defaults.apic.fabric_policies.spine_interface_profiles.name_suffix}"]

  depends_on = [
    module.aci_fabric_spine_interface_profile_manual,
    module.aci_fabric_spine_interface_profile_auto,
    module.aci_fabric_spine_switch_policy_group,
  ]
}

module "aci_fabric_leaf_interface_profile_auto" {
  source  = "netascode/fabric-leaf-interface-profile/aci"
  version = "0.1.0"

  for_each = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "leaf" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_fabric_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_fabric_leaf_switch_interface_profiles)) && local.modules.aci_fabric_leaf_interface_profile && var.manage_fabric_policies }
  name     = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.leaf_interface_profile_name, local.defaults.apic.fabric_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
}

module "aci_fabric_leaf_interface_profile_manual" {
  source  = "netascode/fabric-leaf-interface-profile/aci"
  version = "0.1.0"

  for_each = { for prof in try(local.fabric_policies.leaf_interface_profiles, []) : prof.name => prof if local.modules.aci_fabric_leaf_interface_profile && var.manage_fabric_policies }
  name     = "${each.value.name}${local.defaults.apic.fabric_policies.leaf_interface_profiles.name_suffix}"
}

module "aci_fabric_spine_interface_profile_auto" {
  source  = "netascode/fabric-spine-interface-profile/aci"
  version = "0.1.0"

  for_each = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "spine" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_fabric_spine_switch_interface_profiles, local.defaults.apic.auto_generate_fabric_spine_switch_interface_profiles)) && local.modules.aci_fabric_spine_interface_profile && var.manage_fabric_policies }
  name     = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.fabric_policies.spine_interface_profile_name, local.defaults.apic.fabric_policies.spine_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
}

module "aci_fabric_spine_interface_profile_manual" {
  source  = "netascode/fabric-spine-interface-profile/aci"
  version = "0.1.0"

  for_each = { for prof in try(local.fabric_policies.spine_interface_profiles, []) : prof.name => prof if local.modules.aci_fabric_spine_interface_profile && var.manage_fabric_policies }
  name     = "${each.value.name}${local.defaults.apic.fabric_policies.spine_interface_profiles.name_suffix}"
}

module "aci_external_connectivity_policy" {
  source  = "netascode/external-connectivity-policy/aci"
  version = "0.2.1"

  count        = try(local.fabric_policies.external_connectivity_policy.name, null) != null && local.modules.aci_external_connectivity_policy && var.manage_fabric_policies ? 1 : 0
  name         = "${local.fabric_policies.external_connectivity_policy.name}${local.defaults.apic.fabric_policies.external_connectivity_policy.name_suffix}"
  route_target = try(local.fabric_policies.external_connectivity_policy.route_target, local.defaults.apic.fabric_policies.external_connectivity_policy.route_target)
  fabric_id    = try(local.fabric_policies.external_connectivity_policy.fabric_id, local.defaults.apic.fabric_policies.external_connectivity_policy.fabric_id)
  site_id      = try(local.fabric_policies.external_connectivity_policy.site_id, local.defaults.apic.fabric_policies.external_connectivity_policy.site_id)
  bgp_password = try(local.fabric_policies.external_connectivity_policy.bgp_password, null)
  routing_profiles = [for rp in try(local.fabric_policies.external_connectivity_policy.routing_profiles, []) : {
    name        = rp.name
    description = try(rp.description, "")
    subnets     = try(rp.subnets, [])
  }]
  data_plane_teps = [for pod in try(local.pod_policies.pods, []) : {
    pod_id = pod.id
    ip     = try(pod.data_plane_tep, null)
  } if try(pod.data_plane_tep, null) != null]
  unicast_teps = [for pod in try(local.pod_policies.pods, []) : {
    pod_id = pod.id
    ip     = try(pod.unicast_tep, null)
  } if try(pod.unicast_tep, null) != null]
}

module "aci_infra_dscp_translation_policy" {
  source  = "netascode/infra-dscp-translation-policy/aci"
  version = "0.1.0"

  count         = local.modules.aci_infra_dscp_translation_policy == true && var.manage_fabric_policies ? 1 : 0
  admin_state   = try(local.fabric_policies.infra_dscp_translation_policy.admin_state, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.admin_state)
  control_plane = try(local.fabric_policies.infra_dscp_translation_policy.control_plane, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.control_plane)
  level_1       = try(local.fabric_policies.infra_dscp_translation_policy.level_1, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_1)
  level_2       = try(local.fabric_policies.infra_dscp_translation_policy.level_2, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_2)
  level_3       = try(local.fabric_policies.infra_dscp_translation_policy.level_3, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_3)
  level_4       = try(local.fabric_policies.infra_dscp_translation_policy.level_4, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_4)
  level_5       = try(local.fabric_policies.infra_dscp_translation_policy.level_5, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_5)
  level_6       = try(local.fabric_policies.infra_dscp_translation_policy.level_6, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.level_6)
  policy_plane  = try(local.fabric_policies.infra_dscp_translation_policy.policy_plane, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.policy_plane)
  span          = try(local.fabric_policies.infra_dscp_translation_policy.span, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.span)
  traceroute    = try(local.fabric_policies.infra_dscp_translation_policy.traceroute, local.defaults.apic.fabric_policies.infra_dscp_translation_policy.traceroute)
}

module "aci_vmware_vmm_domain" {
  source  = "netascode/vmware-vmm-domain/aci"
  version = "0.2.5"

  for_each                    = { for vmm in try(local.fabric_policies.vmware_vmm_domains, []) : vmm.name => vmm if local.modules.aci_vmware_vmm_domain && var.manage_fabric_policies }
  name                        = "${each.value.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}"
  access_mode                 = try(each.value.access_mode, local.defaults.apic.fabric_policies.vmware_vmm_domains.access_mode)
  delimiter                   = try(each.value.delimiter, local.defaults.apic.fabric_policies.vmware_vmm_domains.delimiter)
  tag_collection              = try(each.value.tag_collection, local.defaults.apic.fabric_policies.vmware_vmm_domains.tag_collection)
  vlan_pool                   = "${each.value.vlan_pool}${local.defaults.apic.access_policies.vlan_pools.name_suffix}"
  vswitch_cdp_policy          = try(each.value.vswitch.cdp_policy, "")
  vswitch_lldp_policy         = try(each.value.vswitch.lldp_policy, "")
  vswitch_port_channel_policy = try(each.value.vswitch.port_channel_policy, "")
  vswitch_mtu_policy          = try(each.value.vswitch.mtu_policy, "")
  credential_policies = [for cp in try(each.value.credential_policies, []) : {
    name     = "${cp.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix}"
    username = cp.username
    password = cp.password
  }]
  vcenters = [for vc in try(each.value.vcenters, []) : {
    name              = "${vc.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.name_suffix}"
    hostname_ip       = vc.hostname_ip
    datacenter        = vc.datacenter
    credential_policy = try("${vc.credential_policy}${local.defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix}", null)
    dvs_version       = try(vc.dvs_version, local.defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.dvs_version)
    statistics        = try(vc.statistics, local.defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.statistics)
    mgmt_epg_type     = try(vc.mgmt_epg, local.defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.mgmt_epg)
    mgmt_epg_name     = try(vc.mgmt_epg, local.defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
  }]
  vswitch_enhanced_lags = [for vel in try(each.value.vswitch.enhanced_lags, []) : {
    name      = "${vel.name}${local.defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.name_suffix}"
    lb_mode   = try(vel.lb_mode, local.defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.lb_mode)
    mode      = try(vel.mode, local.defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.mode)
    num_links = try(vel.num_links, local.defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.num_links)
  }]
  uplinks = try(each.value.uplinks, [])
}

module "aci_aaa" {
  source  = "netascode/aaa/aci"
  version = "0.1.0"

  count                    = local.modules.aci_aaa == true && var.manage_fabric_policies ? 1 : 0
  remote_user_login_policy = try(local.fabric_policies.aaa.remote_user_login_policy, local.defaults.apic.fabric_policies.aaa.remote_user_login_policy)
  default_fallback_check   = try(local.fabric_policies.aaa.default_fallback_check, local.defaults.apic.fabric_policies.aaa.default_fallback_check)
  default_realm            = try(local.fabric_policies.aaa.default_realm, local.defaults.apic.fabric_policies.aaa.default_realm)
  default_login_domain     = try(local.fabric_policies.aaa.default_login_domain, "")
  console_realm            = try(local.fabric_policies.aaa.console_realm, local.defaults.apic.fabric_policies.aaa.console_realm)
  console_login_domain     = try(local.fabric_policies.aaa.console_login_domain, "")
}

module "aci_tacacs" {
  source  = "netascode/tacacs/aci"
  version = "0.1.1"

  for_each            = { for tacacs in try(local.fabric_policies.aaa.tacacs_providers, []) : tacacs.hostname_ip => tacacs if local.modules.aci_tacacs && var.manage_fabric_policies }
  hostname_ip         = each.value.hostname_ip
  description         = try(each.value.description, "")
  protocol            = try(each.value.protocol, local.defaults.apic.fabric_policies.aaa.tacacs_providers.protocol)
  monitoring          = try(each.value.monitoring, local.defaults.apic.fabric_policies.aaa.tacacs_providers.monitoring)
  monitoring_username = try(each.value.monitoring_username, "")
  monitoring_password = try(each.value.monitoring_password, "")
  key                 = try(each.value.key, "")
  port                = try(each.value.port, local.defaults.apic.fabric_policies.aaa.tacacs_providers.port)
  retries             = try(each.value.retries, local.defaults.apic.fabric_policies.aaa.tacacs_providers.retries)
  timeout             = try(each.value.timeout, local.defaults.apic.fabric_policies.aaa.tacacs_providers.timeout)
  mgmt_epg_type       = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.aaa.tacacs_providers.mgmt_epg)
  mgmt_epg_name       = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.aaa.tacacs_providers.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
}

module "aci_user" {
  source  = "netascode/user/aci"
  version = "0.2.1"

  for_each         = { for user in try(local.fabric_policies.aaa.users, []) : user.username => user if local.modules.aci_user && var.manage_fabric_policies }
  username         = each.value.username
  password         = each.value.password
  status           = try(each.value.status, local.defaults.apic.fabric_policies.aaa.users.status)
  certificate_name = try(each.value.certificate_name, "")
  description      = try(each.value.description, "")
  email            = try(each.value.email, "")
  expires          = try(each.value.expires, local.defaults.apic.fabric_policies.aaa.users.expires)
  expire_date      = try(each.value.expire_date, null)
  first_name       = try(each.value.first_name, "")
  last_name        = try(each.value.last_name, "")
  phone            = try(each.value.phone, "")
  domains = [for domain in try(each.value.domains, []) : {
    name = domain.name
    roles = !contains(keys(domain), "roles") ? null : [for role in domain.roles : {
      name           = role.name
      privilege_type = try(role.privilege_type, local.defaults.apic.fabric_policies.aaa.users.domains.roles.privilege_type)
    }]
  }]
  certificates = try(each.value.certificates, [])
  ssh_keys     = try(each.value.ssh_keys, [])
}

module "aci_login_domain" {
  source  = "netascode/login-domain/aci"
  version = "0.2.1"

  for_each       = { for dom in try(local.fabric_policies.aaa.login_domains, []) : dom.name => dom if local.modules.aci_login_domain && var.manage_fabric_policies }
  name           = each.value.name
  description    = try(each.value.description, "")
  realm          = try(each.value.realm, "")
  auth_choice    = try(each.value.auth_choice, local.defaults.apic.fabric_policies.aaa.login_domains.auth_choice)
  ldap_group_map = try(each.value.ldap_group_map, "")
  tacacs_providers = [for prov in try(each.value.tacacs_providers, []) : {
    hostname_ip = prov.hostname_ip
    priority    = try(prov.priority, local.defaults.apic.fabric_policies.aaa.login_domains.tacacs_providers.priority)
  }]
  ldap_providers = [for prov in try(each.value.ldap_providers, []) : {
    hostname_ip = prov.hostname_ip
    priority    = try(prov.priority, local.defaults.apic.fabric_policies.aaa.login_domains.ldap_providers.priority)
  }]

  depends_on = [
    module.aci_tacacs,
  ]
}

module "aci_ca_certificate" {
  source  = "netascode/ca-certificate/aci"
  version = "0.1.0"

  for_each          = { for cert in try(local.fabric_policies.aaa.ca_certificates, []) : cert.name => cert if local.modules.aci_ca_certificate && var.manage_fabric_policies }
  name              = "${each.value.name}${local.defaults.apic.fabric_policies.aaa.ca_certificates.name_suffix}"
  description       = try(each.value.description, "")
  certificate_chain = each.value.certificate_chain
}

module "aci_keyring" {
  source  = "netascode/keyring/aci"
  version = "0.1.1"

  for_each       = { for kr in try(local.fabric_policies.aaa.key_rings, []) : kr.name => kr if local.modules.aci_keyring && var.manage_fabric_policies }
  name           = "${each.value.name}${local.defaults.apic.fabric_policies.aaa.key_rings.name_suffix}"
  description    = try(each.value.description, "")
  ca_certificate = try(each.value.ca_certificate, "")
  certificate    = try(each.value.certificate, "")
  private_key    = try(each.value.private_key, "")

  depends_on = [
    module.aci_ca_certificate
  ]
}

module "aci_geolocation" {
  source  = "netascode/geolocation/aci"
  version = "0.2.0"

  for_each    = { for site in try(local.fabric_policies.geolocation.sites, []) : site.name => site if local.modules.aci_geolocation && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.geolocation.sites.name_suffix}"
  description = try(each.value.description, "")
  buildings = [for building in try(each.value.buildings, []) : {
    name        = "${building.name}${local.defaults.apic.fabric_policies.geolocation.sites.buildings.name_suffix}"
    description = try(building.description, null)
    floors = !contains(keys(building), "floors") ? null : [for floor in building.floors : {
      name        = "${floor.name}${local.defaults.apic.fabric_policies.geolocation.sites.buildings.floors.name_suffix}"
      description = try(floor.description, null)
      rooms = !contains(keys(floor), "rooms") ? null : [for room in floor.rooms : {
        name        = "${room.name}${local.defaults.apic.fabric_policies.geolocation.sites.buildings.floors.rooms.name_suffix}"
        description = try(room.description, null)
        rows = !contains(keys(room), "rows") ? null : [for row in room.rows : {
          name        = "${row.name}${local.defaults.apic.fabric_policies.geolocation.sites.buildings.floors.rooms.rows.name_suffix}"
          description = try(row.description, null)
          racks = !contains(keys(row), "racks") ? null : [for rack in row.racks : {
            name        = "${rack.name}${local.defaults.apic.fabric_policies.geolocation.sites.buildings.floors.rooms.rows.racks.name_suffix}"
            description = try(rack.description, null)
            nodes = !contains(keys(rack), "nodes") ? null : [for node_ in rack.nodes : {
              node_id = node_
              pod_id  = try([for node in local.node_policies.nodes : try(node.pod, 1) if node.id == node_][0], local.defaults.apic.node_policies.nodes.pod)
            }]
          }]
        }]
      }]
    }]
  }]
}

module "aci_remote_location" {
  source  = "netascode/remote-location/aci"
  version = "0.1.1"

  for_each        = { for rl in try(local.fabric_policies.remote_locations, []) : rl.name => rl if local.modules.aci_remote_location && var.manage_fabric_policies }
  name            = "${each.value.name}${local.defaults.apic.fabric_policies.remote_locations.name_suffix}"
  hostname_ip     = each.value.hostname_ip
  description     = try(each.value.description, "")
  auth_type       = try(each.value.auth_type, local.defaults.apic.fabric_policies.remote_locations.auth_type)
  protocol        = each.value.protocol
  path            = try(each.value.path, local.defaults.apic.fabric_policies.remote_locations.path)
  port            = try(each.value.port, 0)
  username        = try(each.value.username, "")
  password        = try(each.value.password, "")
  ssh_private_key = try(each.value.ssh_private_key, "")
  ssh_public_key  = try(each.value.ssh_public_key, "")
  ssh_passphrase  = try(each.value.ssh_passphrase, "")
  mgmt_epg_type   = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.remote_locations.mgmt_epg)
  mgmt_epg_name   = try(each.value.mgmt_epg, local.defaults.apic.fabric_policies.remote_locations.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
}

module "aci_fabric_scheduler" {
  source  = "netascode/fabric-scheduler/aci"
  version = "0.2.0"

  for_each    = { for scheduler in try(local.fabric_policies.schedulers, []) : scheduler.name => scheduler if local.modules.aci_fabric_scheduler && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.schedulers.name_suffix}"
  description = try(each.value.description, "")
  recurring_windows = [for win in try(each.value.recurring_windows, []) : {
    name   = win.name
    day    = try(win.day, local.defaults.apic.fabric_policies.schedulers.recurring_windows.day)
    hour   = try(win.hour, local.defaults.apic.fabric_policies.schedulers.recurring_windows.hour)
    minute = try(win.minute, local.defaults.apic.fabric_policies.schedulers.recurring_windows.minute)
  }]
}

module "aci_config_export" {
  source  = "netascode/config-export/aci"
  version = "0.1.1"

  for_each        = { for ce in try(local.fabric_policies.config_exports, []) : ce.name => ce if local.modules.aci_config_export && var.manage_fabric_policies }
  name            = "${each.value.name}${local.defaults.apic.fabric_policies.config_exports.name_suffix}"
  description     = try(each.value.description, "")
  format          = try(each.value.format, local.defaults.apic.fabric_policies.config_exports.format)
  snapshot        = try(each.value.snapshot, local.defaults.apic.fabric_policies.config_exports.snapshot)
  remote_location = try(each.value.remote_location, "")
  scheduler       = try(each.value.scheduler, "")

  depends_on = [
    module.aci_remote_location,
    module.aci_fabric_scheduler,
  ]
}

module "aci_snmp_trap_policy" {
  source  = "netascode/snmp-trap-policy/aci"
  version = "0.2.1"

  for_each    = { for trap in try(local.fabric_policies.monitoring.snmp_traps, []) : trap.name => trap if local.modules.aci_snmp_trap_policy && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix}"
  description = try(each.value.description, "")
  destinations = [for dest in try(each.value.destinations, []) : {
    hostname_ip   = dest.hostname_ip
    port          = try(dest.port, local.defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.port)
    community     = dest.community
    security      = try(dest.security, local.defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.security)
    version       = try(dest.version, local.defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.version)
    mgmt_epg_type = try(dest.mgmt_epg, local.defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.mgmt_epg)
    mgmt_epg_name = try(dest.mgmt_epg, local.defaults.apic.fabric_policies.monitoring.snmp_traps.destinations.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
  }]
}

module "aci_syslog_policy" {
  source  = "netascode/syslog-policy/aci"
  version = "0.2.1"

  for_each            = { for syslog in try(local.fabric_policies.monitoring.syslogs, []) : syslog.name => syslog if local.modules.aci_syslog_policy && var.manage_fabric_policies }
  name                = "${each.value.name}${local.defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}"
  description         = try(each.value.description, "")
  format              = try(each.value.format, local.defaults.apic.fabric_policies.monitoring.syslogs.format)
  show_millisecond    = try(each.value.show_millisecond, local.defaults.apic.fabric_policies.monitoring.syslogs.show_millisecond)
  admin_state         = try(each.value.admin_state, local.defaults.apic.fabric_policies.monitoring.syslogs.admin_state)
  local_admin_state   = try(each.value.local_admin_state, local.defaults.apic.fabric_policies.monitoring.syslogs.local_admin_state)
  local_severity      = try(each.value.local_severity, local.defaults.apic.fabric_policies.monitoring.syslogs.local_severity)
  console_admin_state = try(each.value.console_admin_state, local.defaults.apic.fabric_policies.monitoring.syslogs.console_admin_state)
  console_severity    = try(each.value.console_severity, local.defaults.apic.fabric_policies.monitoring.syslogs.console_severity)
  destinations = [for dest in try(each.value.destinations, []) : {
    name          = try(dest.name, "")
    hostname_ip   = dest.hostname_ip
    protocol      = try(dest.protocol, null)
    port          = try(dest.port, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.port)
    admin_state   = try(dest.admin_state, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.admin_state)
    format        = try(each.value.format, local.defaults.apic.fabric_policies.monitoring.syslogs.format)
    facility      = try(dest.facility, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.facility)
    severity      = try(dest.severity, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.severity)
    mgmt_epg_type = try(dest.mgmt_epg, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.mgmt_epg)
    mgmt_epg_name = try(dest.mgmt_epg, local.defaults.apic.fabric_policies.monitoring.syslogs.destinations.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
  }]
}

module "aci_monitoring_policy" {
  source  = "netascode/monitoring-policy/aci"
  version = "0.2.1"

  count              = local.modules.aci_monitoring_policy == true && var.manage_fabric_policies ? 1 : 0
  snmp_trap_policies = [for policy in try(local.fabric_policies.monitoring.snmp_traps, []) : "${policy.name}${local.defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix}"]
  syslog_policies = [for policy in try(local.fabric_policies.monitoring.syslogs, []) : {
    name             = "${policy.name}${local.defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}"
    audit            = try(policy.audit, local.defaults.apic.fabric_policies.monitoring.syslogs.audit)
    events           = try(policy.events, local.defaults.apic.fabric_policies.monitoring.syslogs.events)
    faults           = try(policy.faults, local.defaults.apic.fabric_policies.monitoring.syslogs.faults)
    session          = try(policy.session, local.defaults.apic.fabric_policies.monitoring.syslogs.session)
    minimum_severity = try(policy.minimum_severity, local.defaults.apic.fabric_policies.monitoring.syslogs.minimum_severity)
  }]

  depends_on = [
    module.aci_snmp_trap_policy,
    module.aci_syslog_policy,
  ]
}

module "aci_management_access_policy" {
  source  = "netascode/management-access-policy/aci"
  version = "0.1.0"

  for_each                     = { for policy in try(local.fabric_policies.pod_policies.management_access_policies, []) : policy.name => policy if local.modules.aci_management_access_policy && var.manage_fabric_policies }
  name                         = "${each.value.name}${local.defaults.apic.fabric_policies.pod_policies.management_access_policies.name_suffix}"
  description                  = try(each.value.description, "")
  telnet_admin_state           = try(each.value.telnet.admin_state, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.telnet.admin_state)
  telnet_port                  = try(each.value.telnet.port, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.telnet.port)
  ssh_admin_state              = try(each.value.ssh.admin_state, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.admin_state)
  ssh_password_auth            = try(each.value.ssh.password_auth, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.password_auth)
  ssh_port                     = try(each.value.ssh.port, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.port)
  ssh_aes128_ctr               = try(each.value.ssh.aes128_ctr, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes128_ctr)
  ssh_aes128_gcm               = try(each.value.ssh.aes128_gcm, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes128_gcm)
  ssh_aes192_ctr               = try(each.value.ssh.aes192_ctr, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes192_ctr)
  ssh_aes256_ctr               = try(each.value.ssh.aes256_ctr, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes256_ctr)
  ssh_chacha                   = try(each.value.ssh.chacha, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.chacha)
  ssh_hmac_sha1                = try(each.value.ssh.hmac_sha1, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha1)
  ssh_hmac_sha2_256            = try(each.value.ssh.hmac_sha2_256, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha2_256)
  ssh_hmac_sha2_512            = try(each.value.ssh.hmac_sha2_512, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha2_512)
  https_admin_state            = try(each.value.https.admin_state, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.admin_state)
  https_client_cert_auth_state = try(each.value.https.client_cert_auth_state, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.client_cert_auth_state)
  https_port                   = try(each.value.https.port, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.port)
  https_dh                     = try(each.value.https.dh, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.dh)
  https_tlsv1                  = try(each.value.https.tlsv1, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1)
  https_tlsv1_1                = try(each.value.https.tlsv1_1, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1_1)
  https_tlsv1_2                = try(each.value.https.tlsv1_2, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1_2)
  https_keyring                = try(each.value.https.key_ring, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.https.key_ring)
  http_admin_state             = try(each.value.http.admin_state, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.http.admin_state)
  http_port                    = try(each.value.http.port, local.defaults.apic.fabric_policies.pod_policies.management_access_policies.http.port)
}

module "aci_interface_type" {
  source  = "netascode/interface-type/aci"
  version = "0.1.0"

  for_each = { for type in local.interface_types : type.key => type if local.modules.aci_interface_type && var.manage_fabric_policies }
  pod_id   = each.value.pod_id
  node_id  = each.value.node_id
  module   = each.value.module
  port     = each.value.port
  type     = each.value.type
}

module "aci_smart_licensing" {
  source  = "netascode/smart-licensing/aci"
  version = "0.1.2"

  count              = local.modules.aci_smart_licensing == true && try(local.fabric_policies.smart_licensing.registration_token, "") != "" && var.manage_fabric_policies ? 1 : 0
  mode               = try(local.fabric_policies.smart_licensing.mode, local.defaults.apic.fabric_policies.smart_licensing.mode)
  registration_token = try(local.fabric_policies.smart_licensing.registration_token, "")
  url                = try(local.fabric_policies.smart_licensing.url, local.defaults.apic.fabric_policies.smart_licensing.url)
  proxy_hostname_ip  = try(local.fabric_policies.smart_licensing.proxy.hostname_ip, "")
  proxy_port         = try(local.fabric_policies.smart_licensing.proxy.port, local.defaults.apic.fabric_policies.smart_licensing.proxy.port)
}

module "aci_health_score_evaluation_policy" {
  source  = "netascode/health-score-evaluation-policy/aci"
  version = "0.1.0"

  count               = local.modules.aci_health_score_evaluation_policy && var.manage_fabric_policies ? 1 : 0
  ignore_acked_faults = try(local.fabric_policies.ignore_acked_faults, local.defaults.apic.fabric_policies.ignore_acked_faults)
}

module "aci_fabric_span_destination_group" {
  source  = "netascode/fabric-span-destination-group/aci"
  version = "0.1.1"

  for_each            = { for span in try(local.fabric_policies.span.destination_groups, []) : span.name => span if local.modules.aci_fabric_span_destination_group && var.manage_fabric_policies }
  name                = "${each.value.name}${local.defaults.apic.fabric_policies.span.destination_groups.name_suffix}"
  description         = try(each.value.description, "")
  tenant              = try(each.value.tenant, "")
  application_profile = try(each.value.application_profile, "")
  endpoint_group      = try(each.value.endpoint_group, "")
  ip                  = try(each.value.ip, "")
  source_prefix       = try(each.value.source_prefix, "")
  dscp                = try(each.value.dscp, local.defaults.apic.fabric_policies.span.destination_groups.dscp)
  flow_id             = try(each.value.flow_id, local.defaults.apic.fabric_policies.span.destination_groups.flow_id)
  mtu                 = try(each.value.mtu, local.defaults.apic.fabric_policies.span.destination_groups.mtu)
  ttl                 = try(each.value.ttl, local.defaults.apic.fabric_policies.span.destination_groups.ttl)
  span_version        = try(each.value.version, local.defaults.apic.fabric_policies.span.destination_groups.version)
  enforce_version     = try(each.value.enforce_version, local.defaults.apic.fabric_policies.span.destination_groups.enforce_version)
}

module "aci_fabric_span_source_group" {
  source  = "netascode/fabric-span-source-group/aci"
  version = "0.1.1"

  for_each    = { for span in try(local.fabric_policies.span.source_groups, []) : span.name => span if local.modules.aci_fabric_span_source_group && var.manage_fabric_policies }
  name        = "${each.value.name}${local.defaults.apic.fabric_policies.span.source_groups.name_suffix}"
  description = try(each.value.description, "")
  admin_state = try(each.value.admin_state, local.defaults.apic.fabric_policies.span.source_groups.admin_state)
  sources = [for s in try(each.value.sources, []) : {
    name          = "${s.name}${local.defaults.apic.fabric_policies.span.source_groups.sources.name_suffix}"
    description   = try(s.description, "")
    direction     = try(s.direction, local.defaults.apic.fabric_policies.span.source_groups.sources.direction)
    span_drop     = try(s.span_drop, local.defaults.apic.fabric_policies.span.source_groups.sources.span_drop)
    tenant        = try(s.tenant, null)
    vrf           = try(s.vrf, null)
    bridge_domain = try(s.bridge_domain, null)
    fabric_paths = [for fp in try(s.fabric_paths, []) : {
      node_id = fp.node_id
      pod_id  = try(fp.pod_id, [for n in local.node_policies.nodes : try(n.pod, local.defaults.apic.node_policies.nodes.pod) if n.id == fp.node_id][0], local.defaults.apic.node_policies.nodes.pod)
      port    = fp.port
      module  = try(fp.module, 1)
    }]
  }]
  destination_name        = "${each.value.destination.name}${local.defaults.apic.fabric_policies.span.destination_groups.name_suffix}"
  destination_description = try(each.value.destination.description, "")
}

module "aci_ldap" {
  source  = "netascode/ldap/aci"
  version = "0.1.0"

  ldap_providers = [for prov in try(local.fabric_policies.aaa.ldap.providers, []) : {
    hostname_ip          = prov.hostname_ip
    description          = try(prov.description, "")
    port                 = try(prov.port, local.defaults.apic.fabric_policies.aaa.ldap.providers.port)
    bind_dn              = try(prov.bind_dn, "")
    base_dn              = try(prov.base_dn, "")
    password             = try(prov.password, "")
    timeout              = try(prov.timeout, local.defaults.apic.fabric_policies.aaa.ldap.providers.timeout)
    retries              = try(prov.retries, local.defaults.apic.fabric_policies.aaa.ldap.providers.retries)
    enable_ssl           = try(prov.enable_ssl, local.defaults.apic.fabric_policies.aaa.ldap.providers.enable_ssl)
    filter               = try(prov.filter, "")
    attribute            = try(prov.attribute, "")
    ssl_validation_level = try(prov.ssl_validation_level, local.defaults.apic.fabric_policies.aaa.ldap.providers.ssl_validation_level)
    mgmt_epg_type        = try(prov.mgmt_epg, local.defaults.apic.fabric_policies.aaa.ldap.providers.mgmt_epg)
    mgmt_epg_name        = try(prov.mgmt_epg, local.defaults.apic.fabric_policies.aaa.ldap.providers.mgmt_epg) == "oob" ? try(local.node_policies.oob_endpoint_group, local.defaults.apic.node_policies.oob_endpoint_group) : try(local.node_policies.inb_endpoint_group, local.defaults.apic.node_policies.inb_endpoint_group)
    monitoring           = try(prov.server_monitoring, local.defaults.apic.fabric_policies.aaa.ldap.providers.server_monitoring)
    monitoring_username  = try(prov.monitoring_username, local.defaults.apic.fabric_policies.aaa.ldap.providers.monitoring_username)
    monitoring_password  = try(prov.monitoring_password, "")
  }]
  group_map_rules = [for rule in try(local.fabric_policies.aaa.ldap.group_map_rules, []) : {
    name        = rule.name
    description = try(rule.description, "")
    group_dn    = try(rule.group_dn, "")
    security_domains = [for dom in try(rule.security_domains, []) : {
      name = dom.name
      roles = [for role in try(dom.roles, []) : {
        name           = role.name
        privilege_type = try(role.privilege_type, local.defaults.apic.fabric_policies.aaa.ldap.group_map_rules.security_domains.roles.privilege_type)
      }]
    }]
  }]
  group_maps = [for map in try(local.fabric_policies.aaa.ldap.group_maps, []) : {
    name  = map.name
    rules = [for rule in try(map.rules, []) : rule.name]
  }]
}
