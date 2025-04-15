resource "aci_rest_managed" "fvEpRetPol" {
  dn         = "uni/tn-${var.tenant}/epRPol-${var.name}"
  class_name = "fvEpRetPol"
  content = {
    descr            = var.description
    name             = var.name
    holdIntvl        = var.hold_interval
    bounceAgeIntvl   = var.bounce_entry_aging == 0 ? "infinite" : var.bounce_entry_aging
    localEpAgeIntvl  = var.local_endpoint_aging == 0 ? "infinite" : var.local_endpoint_aging
    remoteEpAgeIntvl = var.remote_endpoint_aging == 0 ? "infinite" : var.remote_endpoint_aging
    moveFreq         = var.move_frequency == 0 ? "none" : var.move_frequency
  }
}
