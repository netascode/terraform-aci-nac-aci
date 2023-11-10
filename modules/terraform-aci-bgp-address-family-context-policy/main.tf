resource "aci_rest_managed" "bgpCtxAfPol" {
  dn         = "uni/tn-${var.tenant}/bgpCtxAfP-${var.name}"
  class_name = "bgpCtxAfPol"
  content = {
    name         = var.name
    descr        = var.description
    ctrl         = var.enable_host_route_leak == true ? "host-rt-leak" : ""
    eDist        = var.ebgp_distance
    iDist        = var.ibgp_distance
    localDist    = var.local_distance
    maxLocalEcmp = var.local_max_ecmp != 0 ? var.local_max_ecmp : null
    maxEcmp      = var.ebgp_max_ecmp
    maxEcmpIbgp  = var.ibgp_max_ecmp
  }
}
