locals {
  fast_select_standby  = var.fast_select_standby == true ? ["fast-sel-hot-stdby"] : []
  graceful_convergence = concat(local.fast_select_standby, var.graceful_convergence == true ? ["graceful-conv"] : [])
  load_defer           = concat(local.graceful_convergence, var.load_defer == true ? ["load-defer"] : [])
  suspend_individual   = concat(local.load_defer, var.suspend_individual == true ? ["susp-individual"] : [])
  ctrl                 = concat(local.suspend_individual, var.symmetric_hash == true ? ["symmetric-hash"] : [])
}

resource "aci_rest_managed" "lacpLagPol" {
  dn         = "uni/infra/lacplagp-${var.name}"
  class_name = "lacpLagPol"
  content = {
    name     = var.name
    mode     = var.mode
    minLinks = var.min_links
    maxLinks = var.max_links
    ctrl     = join(",", local.ctrl)
  }
}

resource "aci_rest_managed" "l2LoadBalancePol" {
  count      = var.symmetric_hash == true ? 1 : 0
  dn         = "${aci_rest_managed.lacpLagPol.dn}/loadbalanceP"
  class_name = "l2LoadBalancePol"
  content = {
    hashFields = var.hash_key
  }
}
