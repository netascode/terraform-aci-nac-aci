resource "aci_rest_managed" "bgpPeerPfxPol" {
  dn         = "uni/tn-${var.tenant}/bgpPfxP-${var.name}"
  class_name = "bgpPeerPfxPol"
  content = {
    name        = var.name
    descr       = var.description
    action      = var.action
    maxPfx      = var.max_prefixes
    restartTime = var.restart_time
    thresh      = var.threshold
  }
}
