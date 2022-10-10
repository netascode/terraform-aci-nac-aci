terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.1.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.1.1"
    }
  }
}

locals {
  model = yamldecode(data.utils_yaml_merge.model.output)
}

data "utils_yaml_merge" "model" {
  input = concat([for file in fileset(path.module, "../standard/*.yaml") : file(file)], [for file in fileset(path.module, "../standard_52/*.yaml") : file(file)], [file("${path.module}/../../../../../defaults/apic_defaults.yaml")])
}

module "access_policies" {
  source  = "netascode/nac-access-policies/aci"
  version = ">= 0.2.1"

  model = local.model
}

module "fabric_policies" {
  source  = "netascode/nac-fabric-policies/aci"
  version = ">= 0.2.0"

  model = local.model
}

module "pod_policies" {
  source  = "netascode/nac-pod-policies/aci"
  version = ">= 0.1.0"

  model = local.model
}

module "node_policies" {
  source  = "netascode/nac-node-policies/aci"
  version = ">= 0.2.1"

  model = local.model

  depends_on = [module.access_policies]
}

module "interface_policies" {
  source  = "netascode/nac-interface-policies/aci"
  version = ">= 0.2.0"

  for_each = { for node in lookup(lookup(local.model.apic, "interface_policies", {}), "nodes", []) : node.id => node }
  model    = local.model
  node_id  = each.value.id

  depends_on = [module.access_policies]
}

module "tenant" {
  source  = "netascode/nac-tenant/aci"
  version = ">= 0.2.3"

  for_each    = toset([for tenant in lookup(local.model.apic, "tenants", {}) : tenant.name])
  model       = local.model
  tenant_name = each.value
}
