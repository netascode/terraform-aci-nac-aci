locals {
  access_fex_interface_profiles = flatten([
    for node in local.nodes : [
      for fex in try(node.fexes, []) : {
        key  = format("%s/%s", node.id, fex.id)
        name = replace("${node.id}:${node.name}:${fex.id}", "/^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$/", replace(replace(replace(try(local.access_policies.fex_profile_name, local.defaults.apic.access_policies.fex_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"), "\\g<fex>", "$${fex}"))
      }
    ] if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false
  ])
}

module "aci_access_fex_interface_profile_auto" {
  source = "./modules/terraform-aci-access-fex-interface-profile"

  for_each = { for profile in local.access_fex_interface_profiles : profile.key => profile if local.modules.aci_access_fex_interface_profile && var.manage_interface_policies }
  name     = each.value.name
}

locals {
  access_leaf_interface_selectors = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key                   = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        name                  = replace(format("%s:%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port), "/^(?P<mod>.+):(?P<port>.+)$/", replace(replace(try(local.access_policies.leaf_interface_selector_name, local.defaults.apic.access_policies.leaf_interface_selector_name), "\\g<mod>", "$${mod}"), "\\g<port>", "$${port}"))
        description           = try(local.apic.interface_selector_description, local.defaults.apic.interface_selector_description) ? try(interface.description, "") : ""
        interface_profile     = replace("${node.id}:${node.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_interface_profile_name, local.defaults.apic.access_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
        fex_id                = try(interface.fex_id, 0)
        fex_interface_profile = try(replace("${node.id}:${node.name}:${interface.fex_id}", "/^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$/", replace(replace(replace(try(local.access_policies.fex_profile_name, local.defaults.apic.access_policies.fex_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"), "\\g<fex>", "$${fex}")), "")
        policy_group          = try("${interface.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
        policy_group_type     = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == interface.policy_group][0], "access")
        port_blocks = [{
          description = try(interface.description, "")
          name        = format("%s-%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
          from_module = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          from_port   = interface.port
          to_module   = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          to_port     = interface.port
        }]
      }
    ] if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false
  ])
}

module "aci_access_leaf_interface_selector_auto" {
  source = "./modules/terraform-aci-access-leaf-interface-selector"

  for_each              = { for selector in local.access_leaf_interface_selectors : selector.key => selector if local.modules.aci_access_leaf_interface_selector && var.manage_interface_policies }
  name                  = each.value.name
  description           = each.value.description
  interface_profile     = each.value.interface_profile
  fex_id                = each.value.fex_id
  fex_interface_profile = each.value.fex_interface_profile
  policy_group          = each.value.policy_group
  policy_group_type     = each.value.policy_group_type
  port_blocks           = each.value.port_blocks

  depends_on = [
    module.aci_access_leaf_interface_profile_auto
  ]
}

locals {
  access_sub_interface_selectors = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : [
        for sub in try(interface.sub_ports, []) : {
          key                   = format("%s/%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port, sub.port)
          name                  = replace(format("%s:%s:%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port, sub.port), "/^(?P<mod>.+):(?P<port>.+):(?P<sport>.+)$/", replace(replace(replace(try(local.access_policies.leaf_interface_selector_sub_port_name, local.defaults.apic.access_policies.leaf_interface_selector_sub_port_name), "\\g<mod>", "$${mod}"), "\\g<port>", "$${port}"), "\\g<sport>", "$${sport}"))
          description           = try(local.apic.interface_selector_description, local.defaults.apic.interface_selector_description) ? try(sub.description, "") : ""
          interface_profile     = replace("${node.id}:${node.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.leaf_interface_profile_name, local.defaults.apic.access_policies.leaf_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
          fex_id                = try(sub.fex_id, 0)
          fex_interface_profile = try(replace("${node.id}:${node.name}:${sub.fex_id}", "/^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$/", replace(replace(replace(try(local.access_policies.fex_profile_name, local.defaults.apic.access_policies.fex_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"), "\\g<fex>", "$${fex}")), "")
          policy_group          = try("${sub.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
          policy_group_type     = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == sub.policy_group][0], "access")
          sub_port_blocks = [{
            description   = try(sub.description, "")
            name          = format("%s-%s-%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port, sub.port)
            from_module   = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
            from_port     = interface.port
            to_module     = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
            to_port       = interface.port
            from_sub_port = sub.port
            to_sub_port   = sub.port
          }]
        }
      ]
    ] if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false
  ])
}

module "aci_access_leaf_interface_selector_sub_auto" {
  source = "./modules/terraform-aci-access-leaf-interface-selector"

  for_each              = { for selector in local.access_sub_interface_selectors : selector.key => selector if local.modules.aci_access_leaf_interface_selector && var.manage_interface_policies }
  name                  = each.value.name
  description           = each.value.description
  interface_profile     = each.value.interface_profile
  fex_id                = each.value.fex_id
  fex_interface_profile = each.value.fex_interface_profile
  policy_group          = each.value.policy_group
  policy_group_type     = each.value.policy_group_type
  sub_port_blocks       = each.value.sub_port_blocks

  depends_on = [
    module.aci_access_leaf_interface_profile_auto
  ]
}

locals {
  access_fex_interface_selectors = flatten([
    for node in local.nodes : [
      for fex in try(node.fexes, []) : [
        for interface in try(fex.interfaces, []) : {
          key               = format("%s/%s/%s/%s", node.id, fex.id, try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module), interface.port)
          name              = replace(format("%s:%s", try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module), interface.port), "/^(?P<mod>.+):(?P<port>.+)$/", replace(replace(try(local.access_policies.fex_interface_selector_name, local.defaults.apic.access_policies.fex_interface_selector_name), "\\g<mod>", "$${mod}"), "\\g<port>", "$${port}"))
          description       = try(local.apic.interface_selector_description, local.defaults.apic.interface_selector_description) ? try(interface.description, "") : ""
          profile_name      = replace("${node.id}:${node.name}:${fex.id}", "/^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$/", replace(replace(replace(try(local.access_policies.fex_profile_name, local.defaults.apic.access_policies.fex_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"), "\\g<fex>", "$${fex}"))
          policy_group      = try("${interface.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "")
          policy_group_type = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == interface.policy_group][0], "access")
          port_blocks = [{
            description = try(interface.description, "")
            name        = format("%s-%s", try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module), interface.port)
            from_module = try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module)
            from_port   = interface.port
            to_module   = try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module)
            to_port     = interface.port
          }]
        }
      ]
    ] if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_leaf_switch_interface_profiles, local.defaults.apic.auto_generate_access_leaf_switch_interface_profiles)) && node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false
  ])
}

module "aci_access_fex_interface_selector_auto" {
  source = "./modules/terraform-aci-access-fex-interface-selector"

  for_each          = { for selector in local.access_fex_interface_selectors : selector.key => selector if local.modules.aci_access_fex_interface_selector && var.manage_interface_policies }
  name              = each.value.name
  description       = each.value.description
  interface_profile = each.value.profile_name
  policy_group      = each.value.policy_group
  policy_group_type = each.value.policy_group_type
  port_blocks       = each.value.port_blocks

  depends_on = [
    module.aci_access_fex_interface_profile_auto
  ]
}

locals {
  access_spine_interface_selectors = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key               = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        name              = replace(format("%s:%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port), "/^(?P<mod>.+):(?P<port>.+)$/", replace(replace(try(local.access_policies.spine_interface_selector_name, local.defaults.apic.access_policies.spine_interface_selector_name), "\\g<mod>", "$${mod}"), "\\g<port>", "$${port}"))
        interface_profile = replace("${node.id}:${node.name}", "/^(?P<id>.+):(?P<name>.+)$/", replace(replace(try(local.access_policies.spine_interface_profile_name, local.defaults.apic.access_policies.spine_interface_profile_name), "\\g<id>", "$${id}"), "\\g<name>", "$${name}"))
        policy_group      = try("${interface.policy_group}${local.defaults.apic.access_policies.spine_interface_policy_groups.name_suffix}", "")
        port_blocks = [{
          name        = format("%s-%s", try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
          description = try(interface.description, "")
          from_module = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          from_port   = interface.port
          to_module   = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          to_port     = interface.port
        }]
      }
    ] if(try(local.apic.auto_generate_switch_pod_profiles, local.defaults.apic.auto_generate_switch_pod_profiles) || try(local.apic.auto_generate_access_spine_switch_interface_profiles, local.defaults.apic.auto_generate_access_spine_switch_interface_profiles)) && node.role == "spine" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == false
  ])
}

module "aci_access_spine_interface_selector_auto" {
  source = "./modules/terraform-aci-access-spine-interface-selector"

  for_each          = { for selector in local.access_spine_interface_selectors : selector.key => selector if local.modules.aci_access_spine_interface_selector && var.manage_interface_policies }
  name              = each.value.name
  interface_profile = each.value.interface_profile
  policy_group      = each.value.policy_group
  port_blocks       = each.value.port_blocks

  depends_on = [
    module.aci_access_spine_interface_profile_auto
  ]
}


locals {
  new_leaf_interface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key                        = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        node_id                    = node.id
        module                     = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
        port                       = interface.port
        policy_group_type          = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == interface.policy_group][0], "access")
        policy_group               = try("${interface.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "system-ports-default")
        breakout                   = try(interface.breakout, "none")
        fex_id                     = try(interface.fex_id, "unspecified")
        description                = try(interface.description, "")
        shutdown                   = try(interface.shutdown, local.defaults.apic.interface_policies.nodes.interfaces.shutdown)
        role                       = node.role
        port_channel_member_policy = try("${interface.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", "")
      } if !try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_leaf_interface_configuration" {
  source = "./modules/terraform-aci-interface-configuration"

  for_each                   = { for int in local.new_leaf_interface_configuration : int.key => int if local.modules.aci_interface_configuration && var.manage_interface_policies }
  node_id                    = each.value.node_id
  module                     = each.value.module
  port                       = each.value.port
  policy_group_type          = each.value.policy_group_type
  policy_group               = each.value.policy_group
  breakout                   = each.value.breakout
  fex_id                     = each.value.fex_id
  description                = each.value.description
  shutdown                   = each.value.shutdown
  role                       = each.value.role
  port_channel_member_policy = each.value.port_channel_member_policy
}

locals {
  new_leaf_subinterface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : [
        for subinterface in try(interface.sub_ports, []) : {
          key                        = format("%s/%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port, subinterface.port)
          node_id                    = node.id
          module                     = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          port                       = interface.port
          sub_port                   = subinterface.port
          policy_group_type          = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == subinterface.policy_group][0], "access")
          policy_group               = try("${subinterface.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "system-ports-default")
          fex_id                     = try(subinterface.fex_id, "unspecified")
          description                = try(subinterface.description, "")
          shutdown                   = try(subinterface.shutdown, local.defaults.apic.interface_policies.nodes.interfaces.sub_ports.shutdown)
          role                       = node.role
          port_channel_member_policy = try("${subinterface.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", "")
        }
      ] if !try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_leaf_interface_configuration_sub" {
  source = "./modules/terraform-aci-interface-configuration"

  for_each                   = { for int in local.new_leaf_subinterface_configuration : int.key => int if local.modules.aci_interface_configuration && var.manage_interface_policies }
  node_id                    = each.value.node_id
  module                     = each.value.module
  port                       = each.value.port
  sub_port                   = each.value.sub_port
  policy_group_type          = each.value.policy_group_type
  policy_group               = each.value.policy_group
  fex_id                     = each.value.fex_id
  description                = each.value.description
  shutdown                   = each.value.shutdown
  role                       = each.value.role
  port_channel_member_policy = each.value.port_channel_member_policy

  depends_on = [
    module.aci_leaf_interface_configuration
  ]
}

locals {
  new_fex_interface_configuration = flatten([
    for node in local.nodes : [
      for fex in try(node.fexes, []) : [
        for interface in try(fex.interfaces, []) : {
          key                        = format("%s/%s/%s/%s", node.id, fex.id, try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module), interface.port)
          node_id                    = node.id
          module                     = fex.id
          port                       = try(interface.module, local.defaults.apic.interface_policies.nodes.fexes.interfaces.module)
          sub_port                   = interface.port
          policy_group_type          = try([for pg in local.access_policies.leaf_interface_policy_groups : pg.type if pg.name == interface.policy_group][0], "access")
          policy_group               = try("${interface.policy_group}${local.defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}", "system-ports-default")
          description                = try(interface.description, "")
          shutdown                   = try(interface.shutdown, local.defaults.apic.interface_policies.nodes.fexes.interfaces.shutdown)
          role                       = node.role
          port_channel_member_policy = try("${interface.port_channel_member_policy}${local.defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}", "")
      }]
    ] if node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_interface_configuration_fex" {
  source = "./modules/terraform-aci-interface-configuration"

  for_each                   = { for int in local.new_fex_interface_configuration : int.key => int if local.modules.aci_interface_configuration && var.manage_interface_policies }
  node_id                    = each.value.node_id
  module                     = each.value.module
  port                       = each.value.port
  sub_port                   = each.value.sub_port
  policy_group_type          = each.value.policy_group_type
  policy_group               = each.value.policy_group
  description                = each.value.description
  shutdown                   = each.value.shutdown
  role                       = each.value.role
  port_channel_member_policy = each.value.port_channel_member_policy

  depends_on = [
    module.aci_leaf_interface_configuration,
    module.aci_leaf_interface_configuration_sub
  ]
}

locals {
  new_spine_interface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key          = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        node_id      = node.id
        module       = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
        port         = interface.port
        policy_group = try("${interface.policy_group}${local.defaults.apic.access_policies.spine_interface_policy_groups.name_suffix}", "system-ports-default")
        description  = try(interface.description, "")
        shutdown     = try(interface.shutdown, false)
        role         = node.role
      } if !try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "spine" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_spine_interface_configuration" {
  source = "./modules/terraform-aci-interface-configuration"

  for_each     = { for int in local.new_spine_interface_configuration : int.key => int if local.modules.aci_interface_configuration && var.manage_interface_policies }
  node_id      = each.value.node_id
  module       = each.value.module
  port         = each.value.port
  policy_group = each.value.policy_group
  description  = each.value.description
  shutdown     = each.value.shutdown
  role         = each.value.role
}

locals {
  new_leaf_fabric_interface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key          = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        node_id      = node.id
        module       = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
        port         = interface.port
        policy_group = try("${interface.policy_group}${local.defaults.apic.fabric_policies.leaf_interface_policy_groups.name_suffix}", "system-ports-default")
        description  = try(interface.description, "")
        shutdown     = try(interface.shutdown, false)
        role         = node.role
      } if try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_leaf_fabric_interface_configuration" {
  source = "./modules/terraform-aci-fabric-interface-configuration"

  for_each     = { for int in local.new_leaf_fabric_interface_configuration : int.key => int if local.modules.aci_fabric_interface_configuration && var.manage_interface_policies }
  node_id      = each.value.node_id
  module       = each.value.module
  port         = each.value.port
  policy_group = each.value.policy_group
  description  = each.value.description
  shutdown     = each.value.shutdown
  role         = each.value.role
}

locals {
  new_leaf_fabric_subinterface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : [
        for subinterface in try(interface.sub_ports, []) : {
          key          = format("%s/%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port, subinterface.port)
          node_id      = node.id
          module       = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
          port         = interface.port
          sub_port     = subinterface.port
          policy_group = try("${subinterface.policy_group}${local.defaults.apic.fabric_policies.leaf_interface_policy_groups.name_suffix}", "system-ports-default")
          description  = try(subinterface.description, "")
          shutdown     = try(subinterface.shutdown, false)
          role         = node.role
        }
      ] if try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "leaf" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_leaf_fabric_interface_configuration_sub" {
  source = "./modules/terraform-aci-fabric-interface-configuration"

  for_each     = { for int in local.new_leaf_fabric_subinterface_configuration : int.key => int if local.modules.aci_fabric_interface_configuration && var.manage_interface_policies }
  node_id      = each.value.node_id
  module       = each.value.module
  port         = each.value.port
  sub_port     = each.value.sub_port
  policy_group = each.value.policy_group
  description  = each.value.description
  shutdown     = each.value.shutdown
  role         = each.value.role

  depends_on = [
    module.aci_leaf_fabric_interface_configuration
  ]
}

locals {
  new_spine_fabric_interface_configuration = flatten([
    for node in local.nodes : [
      for interface in try(node.interfaces, []) : {
        key          = format("%s/%s/%s", node.id, try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module), interface.port)
        node_id      = node.id
        module       = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
        port         = interface.port
        policy_group = try("${interface.policy_group}${local.defaults.apic.fabric_policies.spine_interface_policy_groups.name_suffix}", "system-ports-default")
        description  = try(interface.description, "")
        shutdown     = try(interface.shutdown, false)
        role         = node.role
      } if try(interface.fabric, local.defaults.apic.interface_policies.nodes.interfaces.fabric)
    ] if node.role == "spine" && try(local.apic.new_interface_configuration, local.defaults.apic.new_interface_configuration) == true
  ])
}

module "aci_spine_fabric_interface_configuration" {
  source = "./modules/terraform-aci-fabric-interface-configuration"

  for_each     = { for int in local.new_spine_fabric_interface_configuration : int.key => int if local.modules.aci_fabric_interface_configuration && var.manage_interface_policies }
  node_id      = each.value.node_id
  module       = each.value.module
  port         = each.value.port
  policy_group = each.value.policy_group
  description  = each.value.description
  shutdown     = each.value.shutdown
  role         = each.value.role
}
