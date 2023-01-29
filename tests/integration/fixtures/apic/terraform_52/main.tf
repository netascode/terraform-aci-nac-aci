terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}

module "merge" {
  source = "github.com/netascode/terraform-utils-nac-merge.git?ref=main"

  yaml_strings = concat(
    [for file in fileset(path.module, "../standard/*.yaml") : file(file)],
    [for file in fileset(path.module, "../standard_52/*.yaml") : file(file)]
  )
}

module "access_policies" {
  source = "github.com/netascode/terraform-aci-nac-access-policies.git?ref=main"

  model = module.merge.model
}

module "fabric_policies" {
  source = "github.com/netascode/terraform-aci-nac-fabric-policies.git?ref=main"

  model = module.merge.model
}

module "pod_policies" {
  source = "github.com/netascode/terraform-aci-nac-pod-policies.git?ref=main"

  model = module.merge.model
}

module "node_policies" {
  source = "github.com/netascode/terraform-aci-nac-node-policies.git?ref=main"

  model = module.merge.model

  dependencies = [module.access_policies.critical_resources_done]
}

module "interface_policies" {
  source = "github.com/netascode/terraform-aci-nac-interface-policies.git?ref=main"

  for_each = { for node in try(module.merge.model.apic.interface_policies.nodes, []) : node.id => node }
  model    = module.merge.model
  node_id  = each.value.id

  dependencies = [module.access_policies.critical_resources_done]
}

module "tenant" {
  source = "github.com/netascode/terraform-aci-nac-tenant.git?ref=main"

  for_each    = { for tenant in try(module.merge.model.apic.tenants, []) : tenant.name => tenant }
  model       = module.merge.model
  tenant_name = each.value.name

  dependencies = [
    module.access_policies.critical_resources_done,
    module.fabric_policies.critical_resources_done,
  ]
}

resource "local_sensitive_file" "defaults" {
  content  = yamlencode(module.merge.defaults)
  filename = "${path.module}/defaults.yaml"
}
