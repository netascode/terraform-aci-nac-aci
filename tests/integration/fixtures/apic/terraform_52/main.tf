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
  source = "github.com/netascode/terraform-aci-nac-access-policies.git?ref=main"

  model = local.model
}

module "fabric_policies" {
  source = "github.com/netascode/terraform-aci-nac-fabric-policies.git?ref=main"

  model = local.model
}

module "pod_policies" {
  source = "github.com/netascode/terraform-aci-nac-pod-policies.git?ref=main"

  model = local.model
}

module "node_policies" {
  source = "github.com/netascode/terraform-aci-nac-node-policies.git?ref=main"

  model = local.model

  depends_on = [module.access_policies]
}

module "interface_policies" {
  source = "github.com/netascode/terraform-aci-nac-interface-policies.git?ref=main"

  for_each = { for node in lookup(lookup(local.model.apic, "interface_policies", {}), "nodes", []) : node.id => node }
  model    = local.model
  node_id  = each.value.id

  depends_on = [module.access_policies]
}

module "tenant" {
  source = "github.com/netascode/terraform-aci-nac-tenant.git?ref=main"

  for_each    = toset([for tenant in lookup(local.model.apic, "tenants", {}) : tenant.name])
  model       = local.model
  tenant_name = each.value
}
