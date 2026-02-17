resource "aci_rest_managed" "fabricSetupP" {
  dn         = "uni/controller/setuppol/setupp-${var.pod_id}"
  class_name = "fabricSetupP"
  content = {
    podId   = var.pod_id
    podType = "physical"
    tepPool = var.tep_pool
  }
}

resource "aci_rest_managed" "fabricExtRoutablePodSubnet" {
  for_each   = { for extpool in var.external_tep_pools : extpool.prefix => extpool }
  dn         = "${aci_rest_managed.fabricSetupP.dn}/extrtpodsubnet-[${each.value.prefix}]"
  class_name = "fabricExtRoutablePodSubnet"
  content = {
    pool                = each.value.prefix
    reserveAddressCount = each.value.reserved_address_count
    state               = "active"
  }
}

resource "aci_rest_managed" "fabricExtSetupP" {
  for_each   = { for rlpool in var.remote_pools : rlpool.id => rlpool }
  dn         = "uni/controller/setuppol/setupp-${var.pod_id}/extsetupp-${each.key}"
  class_name = "fabricExtSetupP"
  content = {
    extPoolId = each.value.id
    tepPool   = each.value.remote_pool
  }

  depends_on = [
    aci_rest_managed.fabricExtRoutablePodSubnet
  ]
}

resource "aci_rest_managed" "fabricRlGroupP" {
  for_each   = { for rg in var.resiliency_groups : rg.name => rg }
  dn         = "${aci_rest_managed.fabricSetupP.dn}/rlgroupp-${each.value.name}"
  class_name = "fabricRlGroupP"
  content = {
    name  = each.value.name
    descr = try(each.value.description, "")
  }

  depends_on = [
    aci_rest_managed.fabricExtSetupP
  ]
}

resource "aci_rest_managed" "fabricRsRlGroupToExtSetup" {
  for_each = merge([
    for rg in var.resiliency_groups : {
      for pool_id in rg.remote_pool_ids :
      "${rg.name}-${pool_id}" => {
        rg_name = rg.name
        pool_id = pool_id
      }
    }
  ]...)

  dn         = "${aci_rest_managed.fabricRlGroupP[each.value.rg_name].dn}/rsrlGroupToExtSetup-[uni/controller/setuppol/setupp-${var.pod_id}/extsetupp-${each.value.pool_id}]"
  class_name = "fabricRsRlGroupToExtSetup"
  content = {
    tDn = "uni/controller/setuppol/setupp-${var.pod_id}/extsetupp-${each.value.pool_id}"
  }
}
