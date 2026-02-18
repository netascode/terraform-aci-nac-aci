locals {
  apic               = try(local.model.apic, {})
  access_policies    = try(local.apic.access_policies, {})
  fabric_policies    = try(local.apic.fabric_policies, {})
  pod_policies       = try(local.apic.pod_policies, {})
  node_policies      = try(local.apic.node_policies, {})
  interface_policies = try(local.apic.interface_policies, {})

  nodes = [for node in try(local.apic.interface_policies.nodes, []) : {
    id         = node.id
    name       = try([for n in local.node_policies.nodes : n.name if n.id == node.id][0], "")
    role       = try([for n in local.node_policies.nodes : n.role if n.id == node.id][0], "")
    interfaces = try(node.interfaces, [])
    fexes      = try(node.fexes, [])
  } if length(var.managed_interface_policies_nodes) == 0 || contains(var.managed_interface_policies_nodes, node.id)]

  tenants = [for tenant in try(local.apic.tenants, []) : tenant if length(var.managed_tenants) == 0 || contains(var.managed_tenants, tenant.name)]

  # Helper to get all policies per managed tenant and common tenant
  tenant_shared_policies = var.manage_tenants ? {
    for tenant in try(local.apic.tenants, []) : tenant.name => {
      ip_sla_policies = [
        for policy in try(tenant.policies.ip_sla_policies, []) : policy.name
      ]
    } if length(var.managed_tenants) == 0 || contains(var.managed_tenants, tenant.name) || tenant.name == "common"
  } : {}

  interface_types = flatten([
    for node in try(local.interface_policies.nodes, []) : [
      for interface in try(node.interfaces, []) : {
        key     = "${node.id}/${try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)}/${interface.port}"
        pod_id  = try([for n in try(local.node_policies.nodes, []) : try(n.pod, local.defaults.apic.node_policies.nodes.pod) if n.id == node.id][0], local.defaults.apic.node_policies.nodes.pod)
        node_id = node.id
        module  = try(interface.module, local.defaults.apic.interface_policies.nodes.interfaces.module)
        port    = interface.port
        type    = interface.type
      } if try(interface.type, null) != null
    ]
  ])

  leaf_interface_policy_group_mapping = [
    for pg in try(local.access_policies.leaf_interface_policy_groups, []) : {
      name = pg.name
      type = pg.type
      node_ids = [
        for node in try(local.interface_policies.nodes, []) :
        node.id if length([for int in try(node.interfaces, []) : try(int.policy_group, null) if try(int.policy_group, null) == pg.name]) > 0
      ]
      fex_ids = flatten([
        for node in try(local.interface_policies.nodes, []) : [
          for fex in try(node.fexes, []) :
          fex.id if length([for int in try(fex.interfaces, []) : try(int.policy_group, null) if try(int.policy_group, null) == pg.name]) > 0
        ]
      ])
    }
  ]
}
