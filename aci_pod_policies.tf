module "aci_pod_setup" {
  source = "./modules/terraform-aci-pod-setup"

  for_each = { for pod in try(local.pod_policies.pods, []) : pod.id => pod if local.modules.aci_pod_setup && var.manage_pod_policies }
  pod_id   = each.value.id
  tep_pool = try(each.value.tep_pool, null)
  external_tep_pools = [for pool in try(each.value.external_tep_pools, []) : {
    prefix                 = pool.prefix
    reserved_address_count = pool.reserved_address_count
  }]
  remote_pools = [for pool in try(each.value.remote_pools, []) : {
    id          = pool.id
    remote_pool = pool.remote_pool
  }]
}
