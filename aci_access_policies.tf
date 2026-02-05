module "aci_vlan_pool" {
  source = "./modules/terraform-aci-vlan-pool"

  for_each    = { for vp in try(local.access_policies.vlan_pools, []) : vp.name => vp if local.modules.aci_vlan_pool && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.vlan_pools.name_suffix}"
  description = try(each.value.description, "")
  allocation  = try(each.value.allocation, local.defaults.apic.access_policies.vlan_pools.allocation)
  ranges = [for range in try(each.value.ranges, []) : {
    description = try(range.description, "")
    from        = range.from
    to          = try(range.to, range.from)
    allocation  = try(range.allocation, local.defaults.apic.access_policies.vlan_pools.ranges.allocation)
    role        = try(range.role, local.defaults.apic.access_policies.vlan_pools.ranges.role)
  }]
}

module "aci_physical_domain" {
  source = "./modules/terraform-aci-physical-domain"

  for_each             = { for pd in try(local.access_policies.physical_domains, []) : pd.name => pd if local.modules.aci_physical_domain && var.manage_access_policies }
  name                 = "${each.value.name}${local.defaults.apic.access_policies.physical_domains.name_suffix}"
  vlan_pool            = "${each.value.vlan_pool}${local.defaults.apic.access_policies.vlan_pools.name_suffix}"
  vlan_pool_allocation = [for k, v in try(local.access_policies.vlan_pools, []) : try(v.allocation, local.defaults.apic.access_policies.vlan_pools.allocation) if v.name == each.value.vlan_pool][0]
  security_domains     = try(each.value.security_domains, [])

  depends_on = [
    module.aci_vlan_pool,
  ]
}

module "aci_routed_domain" {
  source = "./modules/terraform-aci-routed-domain"

  for_each             = { for rd in try(local.access_policies.routed_domains, []) : rd.name => rd if local.modules.aci_routed_domain && var.manage_access_policies }
  name                 = "${each.value.name}${local.defaults.apic.access_policies.routed_domains.name_suffix}"
  vlan_pool            = try("${each.value.vlan_pool}${local.defaults.apic.access_policies.vlan_pools.name_suffix}", "")
  vlan_pool_allocation = try(each.value.vlan_pool, "") != "" ? [for vp in try(local.access_policies.vlan_pools, []) : try(vp.allocation, local.defaults.apic.access_policies.vlan_pools.allocation) if vp.name == each.value.vlan_pool][0] : "static"
  security_domains     = try(each.value.security_domains, [])
  depends_on = [
    module.aci_vlan_pool,
  ]
}

module "aci_aaep" {
  source = "./modules/terraform-aci-aaep"

  for_each            = { for aaep in try(local.access_policies.aaeps, []) : aaep.name => aaep if local.modules.aci_aaep && var.manage_access_policies }
  name                = "${each.value.name}${local.defaults.apic.access_policies.aaeps.name_suffix}"
  description         = try(each.value.description, "")
  infra_vlan          = try(each.value.infra_vlan, local.defaults.apic.access_policies.aaeps.infra_vlan) == true ? try(local.access_policies.infra_vlan, 0) : 0
  physical_domains    = [for dom in try(each.value.physical_domains, []) : "${dom}${local.defaults.apic.access_policies.physical_domains.name_suffix}"]
  routed_domains      = [for dom in try(each.value.routed_domains, []) : "${dom}${local.defaults.apic.access_policies.routed_domains.name_suffix}"]
  vmware_vmm_domains  = try(each.value.vmware_vmm_domains, [])
  nutanix_vmm_domains = try(each.value.nutanix_vmm_domains, [])
  endpoint_groups     = try(each.value.endpoint_groups, [])

  depends_on = [
    module.aci_physical_domain,
    module.aci_routed_domain,
  ]
}

module "aci_mst_policy" {
  source = "./modules/terraform-aci-mst-policy"

  for_each = { for mst in try(local.access_policies.switch_policies.mst_policies, []) : mst.name => mst if local.modules.aci_mst_policy && var.manage_access_policies }
  name     = "${each.value.name}${local.defaults.apic.access_policies.switch_policies.mst_policies.name_suffix}"
  region   = each.value.region
  revision = each.value.revision
  instances = [for instance in try(each.value.instances, []) : {
    name = instance.name
    id   = instance.id
    vlan_ranges = [for range in try(instance.vlan_ranges, []) : {
      from = range.from
      to   = try(range.to, range.from)
    }]
  }]
}

module "aci_vpc_policy" {
  source = "./modules/terraform-aci-vpc-policy"

  for_each            = { for vpc in try(local.access_policies.switch_policies.vpc_policies, []) : vpc.name => vpc if local.modules.aci_vpc_policy && var.manage_access_policies }
  name                = "${each.value.name}${local.defaults.apic.access_policies.switch_policies.vpc_policies.name_suffix}"
  peer_dead_interval  = try(each.value.peer_dead_interval, local.defaults.apic.access_policies.switch_policies.vpc_policies.peer_dead_interval)
  delay_restore_timer = try(each.value.delay_restore_timer, null)
}

module "aci_bfd_ipv4_policy" {
  source = "./modules/terraform-aci-bfd-policy"

  for_each                  = { for bfd in try(local.access_policies.switch_policies.bfd_ipv4_policies, []) : bfd.name => bfd if local.modules.aci_bfd_policy && var.manage_access_policies }
  name                      = "${each.value.name}${local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.name_suffix}"
  type                      = "ipv4"
  description               = try(each.value.description, "")
  detection_multiplier      = try(each.value.detection_multiplier, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.detection_multiplier)
  min_tx_interval           = try(each.value.min_transmit_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.min_transmit_interval)
  min_rx_interval           = try(each.value.min_receive_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.min_receive_interval)
  slow_timer_interval       = try(each.value.slow_timer_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.slow_timer_interval)
  startup_timer_interval    = try(each.value.startup_timer_interval, null)
  echo_rx_interval          = try(each.value.echo_receive_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.echo_receive_interval)
  echo_frame_source_address = try(each.value.echo_frame_source_address, local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.echo_frame_source_address)
}

module "aci_bfd_ipv6_policy" {
  source = "./modules/terraform-aci-bfd-policy"

  for_each                  = { for bfd in try(local.access_policies.switch_policies.bfd_ipv6_policies, []) : bfd.name => bfd if local.modules.aci_bfd_policy && var.manage_access_policies }
  name                      = "${each.value.name}${local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.name_suffix}"
  type                      = "ipv6"
  description               = try(each.value.description, "")
  detection_multiplier      = try(each.value.detection_multiplier, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.detection_multiplier)
  min_tx_interval           = try(each.value.min_transmit_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.min_transmit_interval)
  min_rx_interval           = try(each.value.min_receive_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.min_receive_interval)
  slow_timer_interval       = try(each.value.slow_timer_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.slow_timer_interval)
  startup_timer_interval    = try(each.value.startup_timer_interval, null)
  echo_rx_interval          = try(each.value.echo_receive_interval, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.echo_receive_interval)
  echo_frame_source_address = try(each.value.echo_frame_source_address, local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.echo_frame_source_address)
}

module "aci_forwarding_scale_policy" {
  source = "./modules/terraform-aci-forwarding-scale-policy"

  for_each = { for fs in try(local.access_policies.switch_policies.forwarding_scale_policies, []) : fs.name => fs if local.modules.aci_forwarding_scale_policy && var.manage_access_policies }
  name     = "${each.value.name}${local.defaults.apic.access_policies.switch_policies.forwarding_scale_policies.name_suffix}"
  profile  = try(each.value.profile, local.defaults.apic.access_policies.switch_policies.forwarding_scale_policies.profile)
}

module "aci_access_leaf_switch_policy_group" {
  source = "./modules/terraform-aci-access-leaf-switch-policy-group"

  for_each                = { for pg in try(local.access_policies.leaf_switch_policy_groups, []) : pg.name => pg if local.modules.aci_access_leaf_switch_policy_group && var.manage_access_policies }
  name                    = "${each.value.name}${local.defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix}"
  forwarding_scale_policy = try("${each.value.forwarding_scale_policy}${local.defaults.apic.access_policies.switch_policies.forwarding_scale_policies.name_suffix}", "")
  bfd_ipv4_policy         = try("${each.value.bfd_ipv4_policy}${local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.name_suffix}", "")
  bfd_ipv6_policy         = try("${each.value.bfd_ipv6_policy}${local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.name_suffix}", "")

  depends_on = [
    module.aci_forwarding_scale_policy,
    module.aci_bfd_ipv4_policy,
    module.aci_bfd_ipv6_policy,
  ]
}

module "aci_access_spine_switch_policy_group" {
  source = "./modules/terraform-aci-access-spine-switch-policy-group"

  for_each        = { for pg in try(local.access_policies.spine_switch_policy_groups, []) : pg.name => pg if local.modules.aci_access_spine_switch_policy_group && var.manage_access_policies }
  name            = "${each.value.name}${local.defaults.apic.access_policies.spine_switch_policy_groups.name_suffix}"
  lldp_policy     = try("${each.value.lldp_policy}${local.defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix}", "")
  bfd_ipv4_policy = try("${each.value.bfd_ipv4_policy}${local.defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.name_suffix}", "")
  bfd_ipv6_policy = try("${each.value.bfd_ipv6_policy}${local.defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.name_suffix}", "")

  depends_on = [
    module.aci_lldp_policy,
    module.aci_bfd_ipv4_policy,
    module.aci_bfd_ipv6_policy,
  ]
}

module "aci_access_leaf_switch_profile_auto" {
  source = "./modules/terraform-aci-access-leaf-switch-profile"

  for_each           = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "leaf" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && local.modules.aci_access_leaf_switch_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name               = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_switch_profile_name, local.defaults.apic.access_policies.leaf_switch_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
  interface_profiles = [replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_interface_profile_name, local.defaults.apic.access_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))]
  selectors = [{
    name         = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_switch_selector_name, local.defaults.apic.access_policies.leaf_switch_selector_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
    policy_group = try("${each.value.access_policy_group}${local.defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix}", null)
    node_blocks = [{
      name = each.value.id
      from = each.value.id
      to   = each.value.id
    }]
  }]

  depends_on = [
    module.aci_access_leaf_interface_profile_manual,
    module.aci_access_leaf_interface_profile_auto,
    module.aci_access_leaf_switch_policy_group,
  ]
}

module "aci_access_leaf_switch_profile_manual" {
  source = "./modules/terraform-aci-access-leaf-switch-profile"

  for_each = { for prof in try(local.access_policies.leaf_switch_profiles, []) : prof.name => prof if local.modules.aci_access_leaf_switch_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name     = "${each.value.name}${local.defaults.apic.access_policies.leaf_switch_profiles.name_suffix}"
  selectors = [for selector in try(each.value.selectors, []) : {
    name         = "${selector.name}${local.defaults.apic.access_policies.leaf_switch_profiles.selectors.name_suffix}"
    policy_group = try("${selector.policy}${local.defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix}", null)
    node_blocks = [for block in try(selector.node_blocks, []) : {
      name = "${block.name}${local.defaults.apic.access_policies.leaf_switch_profiles.selectors.node_blocks.name_suffix}"
      from = block.from
      to   = try(block.to, block.from)
    }]
  }]
  interface_profiles = [for profile in try(each.value.interface_profiles, []) : "${profile}${local.defaults.apic.access_policies.leaf_interface_profiles.name_suffix}"]

  depends_on = [
    module.aci_access_leaf_interface_profile_manual,
    module.aci_access_leaf_interface_profile_auto,
    module.aci_access_leaf_switch_policy_group,
  ]
}

module "aci_access_leaf_switch_configuration" {
  source = "./modules/terraform-aci-switch-configuration"

  for_each            = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "leaf" && local.modules.aci_switch_configuration && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true && var.manage_access_policies }
  node_id             = each.value.id
  role                = each.value.role
  access_policy_group = try("${each.value.access_policy_group}${local.defaults.apic.access_policies.leaf_switch_policy_groups.name_suffix}", "")

  depends_on = [
    module.aci_access_leaf_switch_policy_group,
  ]
}

module "aci_access_spine_switch_profile_auto" {
  source = "./modules/terraform-aci-access-spine-switch-profile"

  for_each           = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "spine" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_spine_switch_interface_profiles, local.defaults.apic.auto_generate_access_spine_switch_interface_profiles)) && local.modules.aci_access_spine_switch_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name               = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.spine_switch_profile_name, local.defaults.apic.access_policies.spine_switch_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
  interface_profiles = [replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.spine_interface_profile_name, local.defaults.apic.access_policies.spine_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))]
  selectors = [{
    name         = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.spine_switch_selector_name, local.defaults.apic.access_policies.spine_switch_selector_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
    policy_group = try("${each.value.access_policy_group}${local.defaults.apic.access_policies.spine_switch_policy_groups.name_suffix}", null)
    node_blocks = [{
      name = each.value.id
      from = each.value.id
      to   = each.value.id
    }]
  }]

  depends_on = [
    module.aci_access_spine_interface_profile_manual,
    module.aci_access_spine_interface_profile_auto,
  ]
}

module "aci_access_spine_switch_profile_manual" {
  source = "./modules/terraform-aci-access-spine-switch-profile"

  for_each = { for prof in try(local.access_policies.spine_switch_profiles, []) : prof.name => prof if local.modules.aci_access_spine_switch_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name     = each.value.name
  selectors = [for selector in try(each.value.selectors, []) : {
    name         = "${selector.name}${local.defaults.apic.access_policies.spine_switch_profiles.selectors.name_suffix}"
    policy_group = try("${selector.policy}${local.defaults.apic.access_policies.spine_switch_policy_groups.name_suffix}", null)
    node_blocks = [for block in try(selector.node_blocks, []) : {
      name = "${block.name}${local.defaults.apic.access_policies.spine_switch_profiles.selectors.node_blocks.name_suffix}"
      from = block.from
      to   = try(block.to, block.from)
    }]
  }]
  interface_profiles = [for profile in try(each.value.interface_profiles, []) : "${profile}${local.defaults.apic.access_policies.spine_interface_profiles.name_suffix}"]

  depends_on = [
    module.aci_access_spine_interface_profile_manual,
    module.aci_access_spine_interface_profile_auto,
  ]
}

module "aci_access_spine_switch_configuration" {
  source = "./modules/terraform-aci-switch-configuration"

  for_each            = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "spine" && local.modules.aci_switch_configuration && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true && var.manage_access_policies }
  node_id             = each.value.id
  role                = each.value.role
  access_policy_group = try("${each.value.access_policy_group}${local.defaults.apic.access_policies.spine_switch_policy_groups.name_suffix}", "")

  depends_on = [
    module.aci_access_spine_switch_policy_group,
  ]
}

module "aci_cdp_policy" {
  source = "./modules/terraform-aci-cdp-policy"

  for_each    = { for cdp in try(local.access_policies.interface_policies.cdp_policies, []) : cdp.name => cdp if local.modules.aci_cdp_policy && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix}"
  admin_state = each.value.admin_state
}

module "aci_data_plane_policing_policy" {
  source = "./modules/terraform-aci-data-plane-policing-policy"

  for_each             = { for dpp in try(local.access_policies.interface_policies.data_plane_policing_policies, []) : dpp.name => dpp if local.modules.aci_data_plane_policing_policy && var.manage_access_policies }
  name                 = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.name_suffix}"
  admin_state          = try(each.value.admin_state, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.admin_state)
  type                 = try(each.value.type, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.type)
  mode                 = try(each.value.mode, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.mode)
  sharing_mode         = try(each.value.sharing_mode, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.sharing_mode)
  rate                 = try(each.value.rate, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.rate)
  rate_unit            = try(each.value.rate_unit, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.rate_unit)
  burst                = try(each.value.burst, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.burst)
  burst_unit           = try(each.value.burst_unit, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.burst_unit)
  conform_action       = try(each.value.conform_action, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.conform_action)
  conform_mark_cos     = try(each.value.conform_action == "mark", false) ? try(each.value.conform_mark_cos, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.conform_mark_cos) : null
  conform_mark_dscp    = try(each.value.conform_action == "mark", false) ? try(each.value.conform_mark_dscp, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.conform_mark_dscp) : null
  exceed_action        = try(each.value.exceed_action, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.exceed_action)
  exceed_mark_cos      = try(each.value.exceed_action == "mark", false) ? try(each.value.exceed_mark_cos, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.exceed_mark_cos) : null
  exceed_mark_dscp     = try(each.value.exceed_action == "mark", false) ? try(each.value.exceed_mark_dscp, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.exceed_mark_dscp) : null
  violate_action       = try(each.value.violate_action, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.violate_action)
  violate_mark_cos     = try(each.value.violate_action == "mark", false) ? try(each.value.violate_mark_cos, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.violate_mark_cos) : null
  violate_mark_dscp    = try(each.value.violate_action == "mark", false) ? try(each.value.violate_mark_dscp, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.violate_mark_dscp) : null
  peak_rate            = try(each.value.type == "2R3C", false) ? try(each.value.peak_rate, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.peak_rate) : null
  peak_rate_unit       = try(each.value.type == "2R3C", false) ? try(each.value.peak_rate_unit, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.peak_rate_unit) : null
  burst_excessive      = try(each.value.type == "2R3C", false) ? try(each.value.burst_excessive, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.burst_excessive) : null
  burst_excessive_unit = try(each.value.type == "2R3C", false) ? try(each.value.burst_excessive_unit, local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.burst_excessive_unit) : null
}

module "aci_lldp_policy" {
  source = "./modules/terraform-aci-lldp-policy"

  for_each       = { for lldp in try(local.access_policies.interface_policies.lldp_policies, []) : lldp.name => lldp if local.modules.aci_lldp_policy && var.manage_access_policies }
  name           = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix}"
  admin_rx_state = each.value.admin_rx_state
  admin_tx_state = each.value.admin_tx_state
  dcbxp_version  = try(each.value.dcbxp_version, null)
}

module "aci_link_level_policy" {
  source = "./modules/terraform-aci-link-level-policy"

  for_each               = { for llp in try(local.access_policies.interface_policies.link_level_policies, []) : llp.name => llp if local.modules.aci_link_level_policy && var.manage_access_policies }
  name                   = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix}"
  speed                  = try(each.value.speed, local.defaults.apic.access_policies.interface_policies.link_level_policies.speed)
  link_delay_interval    = try(each.value.link_delay_interval, null)
  link_debounce_interval = try(each.value.link_debounce_interval, local.defaults.apic.access_policies.interface_policies.link_level_policies.link_debounce_interval)
  auto                   = try(each.value.auto, local.defaults.apic.access_policies.interface_policies.link_level_policies.auto)
  fec_mode               = try(each.value.fec_mode, local.defaults.apic.access_policies.interface_policies.link_level_policies.fec_mode)
  physical_media_type    = try(each.value.physical_media_type, null)
}

module "aci_macsec_parameters_policy" {
  source = "./modules/terraform-aci-macsec-parameters-policy"

  for_each               = { for mpp in try(local.access_policies.interface_policies.macsec_parameters_policies, []) : mpp.name => mpp if local.modules.aci_macsec_parameters_policy && var.manage_access_policies }
  name                   = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.name_suffix}"
  description            = try(each.value.description, "")
  cipher_suite           = try(each.value.cipher_suite, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.cipher_suite)
  key_server_priority    = try(each.value.key_server_priority, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.key_server_priority)
  window_size            = try(each.value.window_size, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.window_size)
  key_expiry_time        = try(each.value.key_expiry_time, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.key_expiry_time) == "disabled" || try(each.value.key_expiry_time, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.key_expiry_time) == 0 ? 0 : each.value.key_expiry_time
  security_policy        = try(each.value.security_policy, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.security_policy)
  confidentiality_offset = try(each.value.confidentiality_offset, local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.confidentiality_offset)
}

locals {
  macsec_keychain_policies = flatten([
    for mkc in try(local.access_policies.interface_policies.macsec_keychain_policies, []) : {
      name        = "${mkc.name}${local.defaults.apic.access_policies.interface_policies.macsec_keychain_policies.name_suffix}"
      description = try(mkc.description, "")
      type        = "access"
      key_policies = [for kp in try(mkc.key_policies, []) : {
        name           = try(kp.name, "")
        key_name       = kp.key_name
        pre_shared_key = kp.pre_shared_key
        description    = try(kp.description, "")
        start_time     = try(kp.start_time, local.defaults.apic.access_policies.interface_policies.macsec_keychain_policies.key_policies.start_time)
        end_time       = try(kp.end_time, local.defaults.apic.access_policies.interface_policies.macsec_keychain_policies.key_policies.end_time)
        }
      ]
    }
  ])
}

module "aci_macsec_keychain_policies" {
  source = "./modules/terraform-aci-macsec-keychain-policies"

  for_each     = { for mkc in try(local.macsec_keychain_policies, []) : mkc.name => mkc if local.modules.aci_macsec_keychain_policies && var.manage_access_policies }
  name         = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.macsec_keychain_policies.name_suffix}"
  type         = each.value.type
  description  = each.value.description
  key_policies = each.value.key_policies
}

module "aci_macsec_interfaces_policy" {
  source = "./modules/terraform-aci-macsec-interfaces-policy"

  for_each                 = { for mip in try(local.access_policies.interface_policies.macsec_interfaces_policies, []) : mip.name => mip if local.modules.aci_macsec_interfaces_policy && var.manage_access_policies }
  name                     = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.macsec_interfaces_policies.name_suffix}"
  description              = try(each.value.description, "")
  admin_state              = try(each.value.admin_state, local.defaults.apic.access_policies.interface_policies.macsec_interfaces_policies.admin_state)
  macsec_keychain_policy   = "${each.value.macsec_keychain_policy}${local.defaults.apic.access_policies.interface_policies.macsec_keychain_policies.name_suffix}"
  macsec_parameters_policy = "${each.value.macsec_parameters_policy}${local.defaults.apic.access_policies.interface_policies.macsec_parameters_policies.name_suffix}"

  depends_on = [
    module.aci_macsec_keychain_policies,
    module.aci_macsec_parameters_policy
  ]
}

module "aci_port_channel_policy" {
  source = "./modules/terraform-aci-port-channel-policy"

  for_each             = { for pc in try(local.access_policies.interface_policies.port_channel_policies, []) : pc.name => pc if local.modules.aci_port_channel_policy && var.manage_access_policies }
  name                 = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix}"
  mode                 = each.value.mode
  min_links            = try(each.value.min_links, local.defaults.apic.access_policies.interface_policies.port_channel_policies.min_links)
  max_links            = try(each.value.max_links, local.defaults.apic.access_policies.interface_policies.port_channel_policies.max_links)
  suspend_individual   = try(each.value.suspend_individual, local.defaults.apic.access_policies.interface_policies.port_channel_policies.suspend_individual)
  graceful_convergence = try(each.value.graceful_convergence, local.defaults.apic.access_policies.interface_policies.port_channel_policies.graceful_convergence)
  fast_select_standby  = try(each.value.fast_select_standby, local.defaults.apic.access_policies.interface_policies.port_channel_policies.fast_select_standby)
  load_defer           = try(each.value.load_defer, local.defaults.apic.access_policies.interface_policies.port_channel_policies.load_defer)
  symmetric_hash       = try(each.value.symmetric_hash, local.defaults.apic.access_policies.interface_policies.port_channel_policies.symmetric_hash)
  hash_key             = try(each.value.hash_key, "")
}

module "aci_port_channel_member_policy" {
  source = "./modules/terraform-aci-port-channel-member-policy"

  for_each = { for pcm in try(local.access_policies.interface_policies.port_channel_member_policies, []) : pcm.name => pcm if local.modules.aci_port_channel_member_policy && var.manage_access_policies }
  name     = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}"
  priority = try(each.value.priority, local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.priority)
  rate     = try(each.value.rate, local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.rate)
}

module "aci_spanning_tree_policy" {
  source = "./modules/terraform-aci-spanning-tree-policy"

  for_each    = { for stp in try(local.access_policies.interface_policies.spanning_tree_policies, []) : stp.name => stp if local.modules.aci_spanning_tree_policy && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.spanning_tree_policies.name_suffix}"
  bpdu_filter = try(each.value.bpdu_filter, local.defaults.apic.access_policies.interface_policies.spanning_tree_policies.bpdu_filter)
  bpdu_guard  = try(each.value.bpdu_guard, local.defaults.apic.access_policies.interface_policies.spanning_tree_policies.bpdu_guard)
}

module "aci_mcp_policy" {
  source = "./modules/terraform-aci-mcp-policy"

  for_each    = { for mcp in try(local.access_policies.interface_policies.mcp_policies, []) : mcp.name => mcp if local.modules.aci_mcp_policy && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.mcp_policies.name_suffix}"
  admin_state = each.value.admin_state
}

module "aci_l2_policy" {
  source = "./modules/terraform-aci-l2-policy"

  for_each         = { for l2 in try(local.access_policies.interface_policies.l2_policies, []) : l2.name => l2 if local.modules.aci_l2_policy && var.manage_access_policies }
  name             = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.l2_policies.name_suffix}"
  vlan_scope       = try(each.value.vlan_scope, local.defaults.apic.access_policies.interface_policies.l2_policies.vlan_scope)
  qinq             = try(each.value.qinq, local.defaults.apic.access_policies.interface_policies.l2_policies.qinq)
  reflective_relay = try(each.value.reflective_relay, local.defaults.apic.access_policies.interface_policies.l2_policies.reflective_relay)
}

module "aci_storm_control_policy" {
  source = "./modules/terraform-aci-storm-control-policy"

  for_each                   = { for sc in try(local.access_policies.interface_policies.storm_control_policies, []) : sc.name => sc if local.modules.aci_storm_control_policy && var.manage_access_policies }
  name                       = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.storm_control_policies.name_suffix}"
  alias                      = try(each.value.alias, "")
  description                = try(each.value.description, "")
  action                     = try(each.value.action, local.defaults.apic.access_policies.interface_policies.storm_control_policies.action)
  broadcast_burst_pps        = try(each.value.broadcast_burst_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_burst_pps)
  broadcast_burst_rate       = try(each.value.broadcast_burst_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_burst_rate)
  broadcast_pps              = try(each.value.broadcast_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_pps)
  broadcast_rate             = try(each.value.broadcast_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_rate)
  multicast_burst_pps        = try(each.value.multicast_burst_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_burst_pps)
  multicast_burst_rate       = try(each.value.multicast_burst_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_burst_rate)
  multicast_pps              = try(each.value.multicast_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_pps)
  multicast_rate             = try(each.value.multicast_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_rate)
  unknown_unicast_burst_pps  = try(each.value.unknown_unicast_burst_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_burst_pps)
  unknown_unicast_burst_rate = try(each.value.unknown_unicast_burst_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_burst_rate)
  unknown_unicast_pps        = try(each.value.unknown_unicast_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_pps)
  unknown_unicast_rate       = try(each.value.unknown_unicast_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_rate)
  burst_pps                  = try(each.value.burst_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.burst_pps)
  burst_rate                 = try(each.value.burst_rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.burst_rate)
  rate_pps                   = try(each.value.rate_pps, local.defaults.apic.access_policies.interface_policies.storm_control_policies.rate_pps)
  rate                       = try(each.value.rate, local.defaults.apic.access_policies.interface_policies.storm_control_policies.rate)
  configuration_type         = try(each.value.rate, each.value.rate_pps, each.value.burst_pps, each.value.burst_rate, false) == false ? "separate" : "all"
}

module "aci_port_security_policy" {
  source = "./modules/terraform-aci-port-security-policy"

  for_each          = { for ps in try(local.access_policies.interface_policies.port_security_policies, []) : ps.name => ps if local.modules.aci_port_security_policy && var.manage_access_policies }
  name              = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.port_security_policies.name_suffix}"
  description       = try(each.value.description, "")
  maximum_endpoints = try(each.value.maximum_endpoints, local.defaults.apic.access_policies.interface_policies.port_security_policies.maximum_endpoints)
  timeout           = try(each.value.timeout, local.defaults.apic.access_policies.interface_policies.port_security_policies.timeout)
}

module "aci_priority_flow_control_policy" {
  source = "./modules/terraform-aci-priority-flow-control-policy"

  for_each    = { for pfc in try(local.access_policies.interface_policies.priority_flow_control_policies, []) : pfc.name => pfc if local.modules.aci_priority_flow_control_policy && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.priority_flow_control_policies.name_suffix}"
  description = try(each.value.description, "")
  admin_state = try(each.value.admin_state, local.defaults.apic.access_policies.interface_policies.priority_flow_control_policies.admin_state)
  auto_state  = try(each.value.auto_state, local.defaults.apic.access_policies.interface_policies.priority_flow_control_policies.auto_state)
}

module "aci_access_leaf_interface_policy_group" {
  source = "./modules/terraform-aci-access-leaf-interface-policy-group"

  for_each                           = { for pg in try(local.access_policies.leaf_interface_policy_groups, []) : pg.name => pg if local.modules.aci_access_leaf_interface_policy_group && var.manage_access_policies }
  name                               = "${each.value.name}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}"
  description                        = try(each.value.description, "")
  type                               = each.value.type
  map                                = try(each.value.map, local.defaults.apic.access_policies.leaf_interface_policy_groups.map)
  link_level_policy                  = try("${each.value.link_level_policy}${local.defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix}", "")
  cdp_policy                         = try("${each.value.cdp_policy}${local.defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix}", "")
  egress_data_plane_policing_policy  = try("${each.value.egress_data_plane_policing_policy}${local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.name_suffix}", "")
  ingress_data_plane_policing_policy = try("${each.value.ingress_data_plane_policing_policy}${local.defaults.apic.access_policies.interface_policies.data_plane_policing_policies.name_suffix}", "")
  lldp_policy                        = try("${each.value.lldp_policy}${local.defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix}", "")
  spanning_tree_policy               = try("${each.value.spanning_tree_policy}${local.defaults.apic.access_policies.interface_policies.spanning_tree_policies.name_suffix}", "")
  macsec_interface_policy            = try("${each.value.macsec_interface_policy}${local.defaults.apic.access_policies.interface_policies.macsec_interfaces_policies.name_suffix}", "")
  mcp_policy                         = try("${each.value.mcp_policy}${local.defaults.apic.access_policies.interface_policies.mcp_policies.name_suffix}", "")
  l2_policy                          = try("${each.value.l2_policy}${local.defaults.apic.access_policies.interface_policies.l2_policies.name_suffix}", "")
  storm_control_policy               = try("${each.value.storm_control_policy}${local.defaults.apic.access_policies.interface_policies.storm_control_policies.name_suffix}", "")
  port_security_policy               = try("${each.value.port_security_policy}${local.defaults.apic.access_policies.interface_policies.port_security_policies.name_suffix}", "")
  priority_flow_control_policy       = try("${each.value.priority_flow_control_policy}${local.defaults.apic.access_policies.interface_policies.priority_flow_control_policies.name_suffix}", "")
  port_channel_policy                = try("${each.value.port_channel_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix}", "")
  port_channel_member_policy         = try("${each.value.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", "")
  netflow_monitor_policies = [for monitor in try(each.value.netflow_monitor_policies, []) : {
    name           = "${monitor.name}${local.defaults.apic.access_policies.interface_policies.netflow_monitors.name_suffix}"
    ip_filter_type = try(monitor.ip_filter_type, local.defaults.apic.access_policies.leaf_interface_policy_groups.netflow_monitor_policies.ip_filter_type)
  }]
  aaep = try("${each.value.aaep}${local.defaults.apic.access_policies.aaeps.name_suffix}", "")

  depends_on = [
    module.aci_link_level_policy,
    module.aci_cdp_policy,
    module.aci_data_plane_policing_policy,
    module.aci_lldp_policy,
    module.aci_spanning_tree_policy,
    module.aci_mcp_policy,
    module.aci_l2_policy,
    module.aci_macsec_interfaces_policy,
    module.aci_storm_control_policy,
    module.aci_port_security_policy,
    module.aci_priority_flow_control_policy,
    module.aci_port_channel_policy,
    module.aci_port_channel_member_policy,
    module.aci_netflow_monitor,
    module.aci_aaep,
  ]
}

module "aci_access_spine_interface_policy_group" {
  source = "./modules/terraform-aci-access-spine-interface-policy-group"

  for_each                = { for pg in try(local.access_policies.spine_interface_policy_groups, []) : pg.name => pg if local.modules.aci_access_spine_interface_policy_group && var.manage_access_policies }
  name                    = "${each.value.name}${local.defaults.apic.access_policies.spine_interface_policy_groups.name_suffix}"
  link_level_policy       = try("${each.value.link_level_policy}${local.defaults.apic.access_policies.interface_policies.link_level_policies.name_suffix}", "")
  cdp_policy              = try("${each.value.cdp_policy}${local.defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix}", "")
  macsec_interface_policy = try("${each.value.macsec_interface_policy}${local.defaults.apic.access_policies.interface_policies.macsec_interfaces_policies.name_suffix}", "")
  aaep                    = try("${each.value.aaep}${local.defaults.apic.access_policies.aaeps.name_suffix}", "")

  depends_on = [
    module.aci_link_level_policy,
    module.aci_cdp_policy,
    module.aci_macsec_interfaces_policy,
    module.aci_aaep,
  ]
}

module "aci_access_leaf_interface_profile_auto" {
  source = "./modules/terraform-aci-access-leaf-interface-profile"

  for_each = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "leaf" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && local.modules.aci_access_leaf_interface_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name     = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_interface_profile_name, local.defaults.apic.access_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
}

module "aci_access_leaf_interface_profile_manual" {
  source = "./modules/terraform-aci-access-leaf-interface-profile"

  for_each    = { for prof in try(local.access_policies.leaf_interface_profiles, []) : prof.name => prof if local.modules.aci_access_leaf_interface_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.leaf_interface_profiles.name_suffix}"
  description = try(each.value.description, "")
}

locals {
  leaf_interface_selectors_manual = flatten([
    for profile in try(local.access_policies.leaf_interface_profiles, []) : [
      for selector in try(profile.selectors, []) : {
        key = "${profile.name}/${selector.name}"
        value = {
          name              = "${selector.name}${local.defaults.apic.access_policies.leaf_interface_profiles.selectors.name_suffix}"
          description       = try(selector.description, "")
          profile_name      = "${profile.name}${local.defaults.apic.access_policies.leaf_interface_profiles.name_suffix}"
          fex_id            = try(selector.fex_id, 0)
          fex_profile       = try("${selector.fex_profile}${local.defaults.apic.access_policies.fex_interface_profiles.name_suffix}", "")
          policy_group      = try("${selector.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
          policy_group_type = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == selector.policy_group][0], strcontains(try(selector.policy_group, ""), "system-breakout") ? "breakout" : "access")
          port_blocks = [for block in try(selector.port_blocks, []) : {
            description                = try(block.description, "")
            name                       = "${block.name}${local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.name_suffix}"
            from_module                = try(block.from_module, local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)
            from_port                  = block.from_port
            to_module                  = try(block.to_module, block.from_module, local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)
            to_port                    = try(block.to_port, block.from_port)
            port_channel_member_policy = try("${block.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", null)
          }]
          sub_port_blocks = [for block in try(selector.sub_port_blocks, []) : {
            description                = try(block.description, "")
            name                       = "${block.name}${local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.name_suffix}"
            from_module                = try(block.from_module, local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)
            from_port                  = block.from_port
            to_module                  = try(block.to_module, block.from_module, local.defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)
            to_port                    = try(block.to_port, block.from_port)
            from_sub_port              = block.from_sub_port
            to_sub_port                = try(block.to_sub_port, block.from_sub_port)
            port_channel_member_policy = try("${block.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", null)
          }]
        }
      }
    ]
  ])
}

module "aci_access_leaf_interface_selector_manual" {
  source = "./modules/terraform-aci-access-leaf-interface-selector"

  for_each              = { for selector in local.leaf_interface_selectors_manual : selector.key => selector.value if local.modules.aci_access_leaf_interface_selector && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  interface_profile     = each.value.profile_name
  name                  = each.value.name
  description           = each.value.description
  fex_id                = each.value.fex_id
  fex_interface_profile = each.value.fex_profile
  policy_group          = each.value.policy_group
  policy_group_type     = each.value.policy_group_type
  port_blocks           = each.value.port_blocks
  sub_port_blocks       = each.value.sub_port_blocks

  depends_on = [
    module.aci_access_leaf_interface_policy_group,
    module.aci_access_leaf_interface_profile_manual,
    module.aci_access_leaf_interface_profile_auto,
  ]
}

module "aci_access_fex_interface_profile_manual" {
  source = "./modules/terraform-aci-access-fex-interface-profile"

  for_each = toset([for fex in try(local.access_policies.fex_interface_profiles, []) : fex.name if local.modules.aci_access_fex_interface_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies])
  name     = "${each.value}${local.defaults.apic.access_policies.fex_interface_profiles.name_suffix}"
}

locals {
  fex_interface_selectors_manual = flatten([
    for profile in try(local.access_policies.fex_interface_profiles, []) : [
      for selector in try(profile.selectors, []) : {
        key = "${profile.name}/${selector.name}"
        value = {
          name              = "${selector.name}${local.defaults.apic.access_policies.fex_interface_profiles.selectors.name_suffix}"
          profile_name      = "${profile.name}${local.defaults.apic.access_policies.fex_interface_profiles.name_suffix}"
          policy_group      = try("${selector.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
          policy_group_type = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == selector.policy_group][0], "access")
          port_blocks = [for block in try(selector.port_blocks, []) : {
            description = try(block.description, "")
            name        = "${block.name}${local.defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.name_suffix}"
            from_module = try(block.from_module, local.defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.from_module)
            from_port   = block.from_port
            to_module   = try(block.to_module, block.from_module, local.defaults.apic.access_policies.fex_interface_profiles.selectors.port_blocks.from_module)
            to_port     = try(block.to_port, block.from_port)
          }]
        }
      }
    ]
  ])
}

module "aci_access_fex_interface_selector_manual" {
  source = "./modules/terraform-aci-access-fex-interface-selector"

  for_each          = { for selector in local.fex_interface_selectors_manual : selector.key => selector.value if local.modules.aci_access_fex_interface_selector && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  interface_profile = each.value.profile_name
  name              = each.value.name
  policy_group      = each.value.policy_group
  policy_group_type = each.value.policy_group_type
  port_blocks       = each.value.port_blocks

  depends_on = [
    module.aci_access_leaf_interface_policy_group,
    module.aci_access_fex_interface_profile_manual,
  ]
}

module "aci_access_spine_interface_profile_auto" {
  source = "./modules/terraform-aci-access-spine-interface-profile"

  for_each = { for node in try(local.node_policies.nodes, []) : node.id => node if node.role == "spine" && (try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_spine_switch_interface_profiles, local.defaults.apic.auto_generate_access_spine_switch_interface_profiles)) && local.modules.aci_access_spine_interface_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name     = replace("${each.value.id}:${each.value.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.spine_interface_profile_name, local.defaults.apic.access_policies.spine_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
}

module "aci_access_spine_interface_profile_manual" {
  source = "./modules/terraform-aci-access-spine-interface-profile"

  for_each = { for prof in try(local.access_policies.spine_interface_profiles, []) : prof.name => prof if local.modules.aci_access_spine_interface_profile && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  name     = "${each.value.name}${local.defaults.apic.access_policies.spine_interface_profiles.name_suffix}"
}

locals {
  spine_interface_selectors_manual = flatten([
    for profile in try(local.access_policies.spine_interface_profiles, []) : [
      for selector in try(profile.selectors, []) : {
        key = "${profile.name}/${selector.name}"
        value = {
          name         = "${selector.name}${local.defaults.apic.access_policies.spine_interface_profiles.selectors.name_suffix}"
          profile_name = "${profile.name}${local.defaults.apic.access_policies.spine_interface_profiles.name_suffix}"
          policy_group = try("${selector.policy_group}${local.defaults.apic.access_policies.spine_interface_policy_groups.name_suffix}", "")
          port_blocks = [for block in try(selector.port_blocks, []) : {
            description = try(block.description, "")
            name        = "${block.name}${local.defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.name_suffix}"
            from_module = try(block.from_module, local.defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.from_module)
            from_port   = block.from_port
            to_module   = try(block.to_module, block.from_module, local.defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.from_module)
            to_port     = try(block.to_port, block.from_port)
          }]
        }
      }
    ]
  ])
}

module "aci_access_spine_interface_selector_manual" {
  source = "./modules/terraform-aci-access-spine-interface-selector"

  for_each          = { for selector in local.spine_interface_selectors_manual : selector.key => selector.value if local.modules.aci_access_spine_interface_selector && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false && var.manage_access_policies }
  interface_profile = each.value.profile_name
  name              = each.value.name
  policy_group      = each.value.policy_group
  port_blocks       = each.value.port_blocks

  depends_on = [
    module.aci_access_spine_interface_policy_group,
    module.aci_access_spine_interface_profile_manual,
    module.aci_access_spine_interface_profile_auto,
  ]
}

module "aci_mcp" {
  source = "./modules/terraform-aci-mcp"

  count               = local.modules.aci_mcp == true && var.manage_access_policies ? 1 : 0
  admin_state         = try(local.access_policies.mcp.admin_state, local.defaults.apic.access_policies.mcp.admin_state)
  per_vlan            = try(local.access_policies.mcp.per_vlan, local.defaults.apic.access_policies.mcp.per_vlan)
  initial_delay       = try(local.access_policies.mcp.initial_delay, local.defaults.apic.access_policies.mcp.initial_delay)
  key                 = try(local.access_policies.mcp.key, local.defaults.apic.access_policies.mcp.key)
  loop_detection      = try(local.access_policies.mcp.loop_detection, local.defaults.apic.access_policies.mcp.loop_detection)
  disable_port_action = try(local.access_policies.mcp.action, local.defaults.apic.access_policies.mcp.action)
  frequency_sec       = try(local.access_policies.mcp.frequency_sec, local.defaults.apic.access_policies.mcp.frequency_sec)
  frequency_msec      = try(local.access_policies.mcp.frequency_msec, local.defaults.apic.access_policies.mcp.frequency_msec)
}

module "aci_qos" {
  source = "./modules/terraform-aci-qos"

  count        = local.modules.aci_qos == true && var.manage_access_policies ? 1 : 0
  preserve_cos = try(local.access_policies.qos.preserve_cos, local.defaults.apic.access_policies.qos.preserve_cos)
  qos_classes = [
    for class in try(local.access_policies.qos.qos_classes, []) : {
      level                = class.level
      admin_state          = try(class.admin_state, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.admin_state if qclass.level == class.level][0])
      mtu                  = try(class.mtu, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.mtu if qclass.level == class.level][0])
      bandwidth_percent    = try(class.bandwidth_percent, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.bandwidth_percent if qclass.level == class.level][0])
      scheduling           = try(class.scheduling, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.scheduling if qclass.level == class.level][0])
      congestion_algorithm = try(class.congestion_algorithm, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.congestion_algorithm if qclass.level == class.level][0])
      minimum_buffer       = try(class.minimum_buffer, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.minimum_buffer if qclass.level == class.level][0])
      pfc_state            = try(class.pfc_state, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.pfc_state if qclass.level == class.level][0])
      no_drop_cos          = try(class.no_drop_cos, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.no_drop_cos if qclass.level == class.level][0])
      pfc_scope            = try(class.pfc_scope, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.pfc_scope if qclass.level == class.level][0])
      ecn                  = try(class.ecn, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.ecn if qclass.level == class.level][0])
      forward_non_ecn      = try(class.forward_non_ecn, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.forward_non_ecn if qclass.level == class.level][0])
      wred_max_threshold   = try(class.wred_max_threshold, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.wred_max_threshold if qclass.level == class.level][0])
      wred_min_threshold   = try(class.wred_min_threshold, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.wred_min_threshold if qclass.level == class.level][0])
      wred_probability     = try(class.wred_probability, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.wred_probability if qclass.level == class.level][0])
      weight               = try(class.weight, [for qclass in local.defaults.apic.access_policies.qos.qos_classes : qclass.weight if qclass.level == class.level][0])
    }
  ]
}

module "aci_access_span_filter_group" {
  source = "./modules/terraform-aci-access-span-filter-group"

  for_each    = { for group in try(local.access_policies.span.filter_groups, []) : group.name => group if local.modules.aci_access_span_filter_group && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.span.filter_groups.name_suffix}"
  description = try(each.value.description, "")
  entries = [for entry in try(each.value.entries, []) : {
    name                  = try("${entry.name}${local.defaults.apic.access_policies.span.filter_groups.entries.name_suffix}", "")
    description           = try(entry.description, "")
    source_ip             = entry.source_ip
    destination_ip        = entry.destination_ip
    ip_protocol           = try(entry.ip_protocol, local.defaults.apic.access_policies.span.filter_groups.entries.ip_protocol)
    source_from_port      = try(entry.source_from_port, local.defaults.apic.access_policies.span.filter_groups.entries.source_from_port)
    source_to_port        = try(entry.source_to_port, entry.source_from_port, local.defaults.apic.access_policies.span.filter_groups.entries.source_from_port)
    destination_from_port = try(entry.destination_from_port, local.defaults.apic.access_policies.span.filter_groups.entries.destination_from_port)
    destination_to_port   = try(entry.destination_to_port, entry.destination_from_port, local.defaults.apic.access_policies.span.filter_groups.entries.destination_from_port)
  }]
}

locals {
  access_span_destination_groups = [for group in try(local.access_policies.span.destination_groups, []) : {
    name                = "${group.name}${local.defaults.apic.access_policies.span.destination_groups.name_suffix}"
    description         = try(group.description, "")
    pod_id              = try(group.pod_id, null)
    node_id             = try(group.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == group.channel][0][0], 0)
    module              = try(group.module, local.defaults.apic.access_policies.span.destination_groups.module)
    port                = try(group.port, 0)
    sub_port            = try(group.sub_port, 0)
    channel             = try("${group.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
    ip                  = try(group.ip, "")
    source_prefix       = try(group.source_prefix, "")
    dscp                = try(group.dscp, local.defaults.apic.access_policies.span.destination_groups.dscp)
    flow_id             = try(group.flow_id, local.defaults.apic.access_policies.span.destination_groups.flow_id)
    mtu                 = try(group.mtu, local.defaults.apic.access_policies.span.destination_groups.mtu)
    ttl                 = try(group.ttl, local.defaults.apic.access_policies.span.destination_groups.ttl)
    span_version        = try(group.version, local.defaults.apic.access_policies.span.destination_groups.version)
    enforce_version     = try(group.enforce_version, local.defaults.apic.access_policies.span.destination_groups.enforce_version)
    tenant              = try(group.tenant, "")
    application_profile = try("${group.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}", "")
    endpoint_group      = try("${group.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}", "")
  }]
}

module "aci_access_span_destination_group" {
  source = "./modules/terraform-aci-access-span-destination-group"

  for_each            = { for group in local.access_span_destination_groups : group.name => group if local.modules.aci_access_span_destination_group && var.manage_access_policies }
  name                = each.value.name
  description         = each.value.description
  pod_id              = each.value.pod_id != null ? each.value.pod_id : try([for node in local.node_policies.nodes : node.pod if node.id == each.value.pod_id][0], local.defaults.apic.node_policies.nodes.pod)
  node_id             = each.value.node_id
  module              = each.value.module
  port                = each.value.port
  sub_port            = each.value.sub_port
  channel             = each.value.channel
  ip                  = each.value.ip
  source_prefix       = each.value.source_prefix
  dscp                = each.value.dscp
  flow_id             = each.value.flow_id
  mtu                 = each.value.mtu
  ttl                 = each.value.ttl
  span_version        = each.value.span_version
  enforce_version     = each.value.enforce_version
  tenant              = each.value.tenant
  application_profile = each.value.application_profile
  endpoint_group      = each.value.endpoint_group
}

locals {
  access_span_source_groups = [for group in try(local.access_policies.span.source_groups, []) : {
    name                    = "${group.name}${local.defaults.apic.access_policies.span.source_groups.name_suffix}"
    description             = try(group.description, "")
    admin_state             = try(group.admin_state, local.defaults.apic.access_policies.span.source_groups.admin_state)
    filter_group            = try("${group.filter_group}${local.defaults.apic.access_policies.span.filter_groups.name_suffix}", "")
    destination_name        = try(group.destination.name, "") != "" ? "${group.destination.name}${local.defaults.apic.access_policies.span.destination_groups.name_suffix}" : null
    destination_description = try(group.destination.description, "")
    sources = [for source in try(group.sources, []) : {
      description         = try(source.description, "")
      name                = source.name
      direction           = try(source.direction, local.defaults.apic.access_policies.span.source_groups.sources.direction)
      span_drop           = try(source.span_drop, local.defaults.apic.access_policies.span.source_groups.sources.span_drop)
      tenant              = try(source.tenant, null)
      application_profile = try(source.application_profile, "") != "" ? "${source.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}" : null
      endpoint_group      = try(source.endpoint_group, "") != "" ? "${source.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}" : null
      l3out               = try(source.l3out, "") != "" ? "${source.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}" : null
      vlan                = try(source.vlan, null)
      access_paths = [for ap in try(source.access_paths, []) : {
        node_id = try(ap.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == ap.channel][0][0], null)
        # set node2_id to "vpc" if channel IPG is vPC, otherwise "null"
        node2_id = try(ap.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == ap.channel && pg.type == "vpc"][0], null)
        fex_id   = try(ap.fex_id, [for pg in local.leaf_interface_policy_group_mapping : pg.fex_ids if pg.name == ap.channel][0][0], null)
        # set fex2_id to "vpc" if channel IPG is vPC, otherwise "null"
        fex2_id  = try(ap.fex2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == ap.channel && pg.type == "vpc"][0], null)
        pod_id   = try(ap.pod_id, null)
        port     = try(ap.port, null)
        sub_port = try(ap.sub_port, null)
        module   = try(ap.module, local.defaults.apic.access_policies.span.source_groups.sources.access_paths.module)
        channel  = try(ap.channel, "") != "" ? "${ap.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}" : null
        type     = try(ap.type, null)
      }]
    }]
  }]
}

module "aci_access_span_source_group" {
  source = "./modules/terraform-aci-access-span-source-group"

  for_each                = { for group in local.access_span_source_groups : group.name => group if local.modules.aci_access_span_source_group && var.manage_access_policies }
  name                    = each.value.name
  description             = each.value.description
  admin_state             = each.value.admin_state
  filter_group            = each.value.filter_group
  destination_name        = each.value.destination_name
  destination_description = each.value.destination_description
  sources = [for source in try(each.value.sources, []) : {
    description         = source.description
    name                = source.name
    direction           = source.direction
    span_drop           = source.span_drop
    tenant              = source.tenant
    application_profile = source.application_profile
    endpoint_group      = source.endpoint_group
    l3out               = source.l3out
    vlan                = source.vlan
    access_paths = [for ap in try(source.access_paths, []) : {
      node_id  = ap.node_id
      node2_id = ap.node2_id == "vpc" ? try([for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == ap.channel][0][1], null) : ap.node2_id
      fex_id   = ap.fex_id
      fex2_id  = ap.fex2_id == "vpc" ? try([for pg in local.leaf_interface_policy_group_mapping : pg.fex_ids if pg.name == ap.channel][0][1], null) : ap.fex2_id
      pod_id   = try(ap.pod_id, [for node in local.node_policies.nodes : node.pod if node.id == ap.node_id][0], local.defaults.apic.node_policies.nodes.pod)
      port     = ap.port
      sub_port = ap.sub_port
      module   = ap.module
      channel  = ap.channel
      type     = ap.type
    }]
  }]
}

module "aci_vspan_destination_group" {
  source = "./modules/terraform-aci-vspan-destination-group"

  for_each    = { for group in try(local.access_policies.vspan.destination_groups, []) : group.name => group if local.modules.aci_vspan_destination_group && var.manage_access_policies }
  name        = "${each.value.name}${local.defaults.apic.access_policies.vspan.destination_groups.name_suffix}"
  description = try(each.value.description, "")
  destinations = [for dest in try(each.value.destinations, []) : {
    name                = "${dest.name}${local.defaults.apic.access_policies.vspan.destination_groups.destinations.name_suffix}"
    description         = try(dest.description, "")
    tenant              = try(dest.tenant, null)
    application_profile = try(dest.application_profile, "") != "" ? "${dest.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}" : null
    endpoint_group      = try(dest.endpoint_group, "") != "" ? "${dest.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}" : null
    endpoint            = try(dest.endpoint, null)
    ip                  = try(dest.ip, null)
    mtu                 = try(dest.mtu, local.defaults.apic.access_policies.vspan.destination_groups.destinations.mtu)
    ttl                 = try(dest.ttl, local.defaults.apic.access_policies.vspan.destination_groups.destinations.ttl)
    flow_id             = try(dest.flow_id, local.defaults.apic.access_policies.vspan.destination_groups.destinations.flow_id)
    dscp                = try(dest.dscp, local.defaults.apic.access_policies.vspan.destination_groups.destinations.dscp)
  }]
}

locals {
  vspan_sessions = [for session in try(local.access_policies.vspan.sessions, []) : {
    name                    = "${session.name}${local.defaults.apic.access_policies.vspan.sessions.name_suffix}"
    description             = try(session.description, "")
    admin_state             = try(session.admin_state, local.defaults.apic.access_policies.vspan.sessions.admin_state)
    destination_name        = try(session.destination.name, "") != "" ? "${session.destination.name}${local.defaults.apic.access_policies.vspan.destination_groups.name_suffix}" : null
    destination_description = try(session.destination.description, "")
    sources = [for source in try(session.sources, []) : {
      description         = try(source.description, "")
      name                = source.name
      direction           = try(source.direction, local.defaults.apic.access_policies.vspan.sessions.sources.direction)
      tenant              = try(source.tenant, null)
      application_profile = try(source.application_profile, "") != "" ? "${source.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}" : null
      endpoint_group      = try(source.endpoint_group, "") != "" ? "${source.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}" : null
      endpoint            = try(source.endpoint, null)
      access_paths = [for ap in try(source.access_paths, []) : {
        node_id = try(ap.node_id, [for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == ap.channel][0][0], null)
        # set node2_id to "vpc" if channel IPG is vPC, otherwise "null"
        node2_id = try(ap.node2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == ap.channel && pg.type == "vpc"][0], null)
        fex_id   = try(ap.fex_id, [for pg in local.leaf_interface_policy_group_mapping : pg.fex_ids if pg.name == ap.channel][0][0], null)
        # set fex2_id to "vpc" if channel IPG is vPC, otherwise "null"
        fex2_id  = try(ap.fex2_id, [for pg in local.leaf_interface_policy_group_mapping : pg.type if pg.name == ap.channel && pg.type == "vpc"][0], null)
        pod_id   = try(ap.pod_id, null)
        port     = try(ap.port, null)
        sub_port = try(ap.sub_port, null)
        module   = try(ap.module, local.defaults.apic.access_policies.vspan.sessions.sources.access_paths.module)
        channel  = try(ap.channel, "") != "" ? "${ap.channel}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}" : null
      }]
    }]
  }]
}

module "aci_vspan_session" {
  source = "./modules/terraform-aci-vspan-session"

  for_each                = { for session in local.vspan_sessions : session.name => session if local.modules.aci_vspan_session && var.manage_access_policies }
  name                    = each.value.name
  description             = each.value.description
  admin_state             = each.value.admin_state
  destination_name        = each.value.destination_name
  destination_description = each.value.destination_description
  sources = [for source in try(each.value.sources, []) : {
    description         = source.description
    name                = source.name
    direction           = source.direction
    tenant              = source.tenant
    application_profile = source.application_profile
    endpoint_group      = source.endpoint_group
    endpoint            = source.endpoint
    access_paths = [for ap in try(source.access_paths, []) : {
      node_id  = ap.node_id
      node2_id = ap.node2_id == "vpc" ? try([for pg in local.leaf_interface_policy_group_mapping : pg.node_ids if pg.name == ap.channel][0][1], null) : ap.node2_id
      fex_id   = ap.fex_id
      fex2_id  = ap.fex2_id == "vpc" ? try([for pg in local.leaf_interface_policy_group_mapping : pg.fex_ids if pg.name == ap.channel][0][1], null) : ap.fex2_id
      pod_id   = try(ap.pod_id, [for node in local.node_policies.nodes : node.pod if node.id == ap.node_id][0], local.defaults.apic.node_policies.nodes.pod)
      port     = ap.port
      sub_port = ap.sub_port
      module   = ap.module
      channel  = ap.channel
    }]
  }]
}

module "aci_ptp_profile" {
  source = "./modules/terraform-aci-ptp-profile"

  for_each          = { for profile in try(local.access_policies.ptp_profiles, []) : profile.name => profile if local.modules.aci_ptp_profile && var.manage_access_policies }
  name              = each.value.name
  announce_interval = try(each.value.announce_interval, local.defaults.apic.access_policies.ptp_profiles.announce_interval)
  announce_timeout  = try(each.value.announce_timeout, local.defaults.apic.access_policies.ptp_profiles.announce_timeout)
  delay_interval    = try(each.value.delay_interval, local.defaults.apic.access_policies.ptp_profiles.delay_interval)
  forwardable       = try(each.value.forwardable, local.defaults.apic.access_policies.ptp_profiles.forwardable)
  priority          = try(each.value.priority, local.defaults.apic.access_policies.ptp_profiles.priority)
  sync_interval     = try(each.value.sync_interval, local.defaults.apic.access_policies.ptp_profiles.sync_interval)
  template          = try(each.value.template, local.defaults.apic.access_policies.ptp_profiles.template)
  mismatch_handling = try(each.value.mismatch_handling, local.defaults.apic.access_policies.ptp_profiles.mismatch_handling)
}

locals {
  infra_dhcp_relay_policies = flatten([
    for policy in try(local.access_policies.dhcp_relay_policies, []) : {
      name        = "${policy.name}${local.defaults.apic.access_policies.dhcp_relay_policies.name_suffix}"
      description = try(policy.description, "")
      providers_ = [for provider in try(policy.providers, []) : {
        ip                      = provider.ip
        type                    = provider.type
        tenant                  = try(provider.tenant, "")
        application_profile     = try("${provider.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}", "")
        endpoint_group          = try("${provider.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}", "")
        l3out                   = try("${provider.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
        external_endpoint_group = try("${provider.external_endpoint_group}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
      }]
    }
  ])
}

module "aci_infra_dhcp_relay_policy" {
  source = "./modules/terraform-aci-infra-dhcp-relay-policy"

  for_each    = { for policy in local.infra_dhcp_relay_policies : policy.name => policy if local.modules.aci_infra_dhcp_relay_policy && var.manage_access_policies }
  name        = each.value.name
  description = each.value.description
  providers_  = each.value.providers_
}

module "aci_netflow_exporter" {
  source = "./modules/terraform-aci-netflow-exporter"

  for_each                = { for exporter in try(local.access_policies.interface_policies.netflow_exporters, []) : exporter.name => exporter if local.modules.aci_netflow_exporter && var.manage_access_policies }
  name                    = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.netflow_exporters.name_suffix}"
  description             = try(each.value.description, "")
  destination_port        = each.value.destination_port
  destination_ip          = each.value.destination_ip
  dscp                    = try(each.value.dscp, local.defaults.apic.access_policies.interface_policies.netflow_exporters.dscp)
  source_type             = try(each.value.source_type, local.defaults.apic.access_policies.interface_policies.netflow_exporters.source_type)
  source_ip               = try(each.value.source_ip, local.defaults.apic.access_policies.interface_policies.netflow_exporters.source_ip)
  epg_type                = try(each.value.epg_type, "")
  tenant                  = try(each.value.tenant, "")
  application_profile     = try("${each.value.application_profile}${local.defaults.apic.tenants.application_profiles.name_suffix}", "")
  endpoint_group          = try("${each.value.endpoint_group}${local.defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}", "")
  vrf                     = try("${each.value.vrf}${local.defaults.apic.tenants.vrfs.name_suffix}", "")
  l3out                   = try("${each.value.l3out}${local.defaults.apic.tenants.l3outs.name_suffix}", "")
  external_endpoint_group = try("${each.value.external_endpoint_group}${local.defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}", "")
}

module "aci_netflow_vmm_exporter" {
  source = "./modules/terraform-aci-netflow-vmm-exporter"

  for_each         = { for exporter in try(local.access_policies.interface_policies.netflow_vmm_exporters, []) : exporter.name => exporter if local.modules.aci_netflow_vmm_exporter && var.manage_access_policies }
  name             = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.netflow_vmm_exporters.name_suffix}"
  description      = try(each.value.description, "")
  destination_port = each.value.destination_port
  destination_ip   = each.value.destination_ip
  source_ip        = try(each.value.source_ip, local.defaults.apic.access_policies.interface_policies.netflow_vmm_exporters.source_ip)
}

module "aci_netflow_monitor" {
  source = "./modules/terraform-aci-netflow-monitor"

  for_each       = { for monitor in try(local.access_policies.interface_policies.netflow_monitors, []) : monitor.name => monitor if local.modules.aci_netflow_monitor && var.manage_access_policies }
  name           = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.netflow_monitors.name_suffix}"
  description    = try(each.value.description, "")
  flow_record    = try("${each.value.flow_record}${local.defaults.apic.access_policies.interface_policies.netflow_records.name_suffix}", "")
  flow_exporters = [for exporter in try(each.value.flow_exporters, []) : "${exporter}${local.defaults.apic.access_policies.interface_policies.netflow_exporters.name_suffix}"]
}

module "aci_netflow_record" {
  source = "./modules/terraform-aci-netflow-record"

  for_each         = { for record in try(local.access_policies.interface_policies.netflow_records, []) : record.name => record if local.modules.aci_netflow_record && var.manage_access_policies }
  name             = "${each.value.name}${local.defaults.apic.access_policies.interface_policies.netflow_records.name_suffix}"
  description      = try(each.value.description, "")
  match_parameters = try(each.value.match_parameters, [])
}

locals {
  access_monitoring_policy = flatten([
    for policy in try(local.access_policies.monitoring.policies, []) : {
      key         = format("%s", policy.name)
      name        = "${policy.name}${local.defaults.apic.access_policies.monitoring.policies.name_suffix}"
      description = try(policy.description, "")
      snmp_trap_policies = [for snmp_policy in try(policy.snmp_traps, []) : {
        name              = "${snmp_policy.name}${local.defaults.apic.access_policies.monitoring.policies.snmp_traps.name_suffix}"
        destination_group = try("${snmp_policy.destination_group}${local.defaults.apic.fabric_policies.monitoring.snmp_traps.name_suffix}", null)
      }]
      syslog_policies = [for syslog_policy in try(policy.syslogs, []) : {
        name              = "${syslog_policy.name}${local.defaults.apic.access_policies.monitoring.policies.syslogs.name_suffix}"
        audit             = try(syslog_policy.audit, local.defaults.apic.access_policies.monitoring.policies.syslogs.audit)
        events            = try(syslog_policy.events, local.defaults.apic.access_policies.monitoring.policies.syslogs.events)
        faults            = try(syslog_policy.faults, local.defaults.apic.access_policies.monitoring.policies.syslogs.faults)
        session           = try(syslog_policy.session, local.defaults.apic.access_policies.monitoring.policies.syslogs.session)
        minimum_severity  = try(syslog_policy.minimum_severity, local.defaults.apic.access_policies.monitoring.policies.syslogs.minimum_severity)
        destination_group = try("${syslog_policy.destination_group}${local.defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}", null)
      }]
      fault_severity_policies = [for fault_policy in try(policy.fault_severity_policies, []) : {
        class = fault_policy.class
        faults = [for fault in try(fault_policy.faults, []) : {
          fault_id         = fault.fault_id
          initial_severity = try(fault.initial_severity, local.defaults.apic.access_policies.monitoring.policies.fault_severity_policies.initial_severity)
          target_severity  = try(fault.target_severity, local.defaults.apic.access_policies.monitoring.policies.fault_severity_policies.target_severity)
          description      = try(fault.description, "")
        }]
      }]
    }
  ])
}

module "aci_access_monitoring_policy" {
  source   = "./modules/terraform-aci-access-monitoring-policy"
  for_each = { for pol in local.access_monitoring_policy : pol.key => pol if local.modules.aci_access_monitoring_policy && var.manage_access_policies }

  name                    = each.value.name
  description             = each.value.description
  snmp_trap_policies      = each.value.snmp_trap_policies
  syslog_policies         = each.value.syslog_policies
  fault_severity_policies = each.value.fault_severity_policies

  depends_on = [
    module.aci_snmp_trap_policy,
    module.aci_syslog_policy,
  ]
}
