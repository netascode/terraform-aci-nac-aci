resource "aci_rest_managed" "bgpCtxPol" {
  dn         = "uni/tn-${var.tenant}/bgpCtxP-${var.name}"
  class_name = "bgpCtxPol"
  content = {
    name       = var.name
    descr      = var.description
    grCtrl     = var.graceful_restart_helper == true ? "helper" : ""
    holdIntvl  = var.hold_interval
    kaIntvl    = var.keepalive_interval
    maxAsLimit = var.maximum_as_limit
    staleIntvl = var.stale_interval
  }
}
