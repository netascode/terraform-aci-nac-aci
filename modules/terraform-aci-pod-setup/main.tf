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