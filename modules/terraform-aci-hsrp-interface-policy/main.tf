resource "aci_rest_managed" "hsrpIfPol" {
  dn         = "uni/tn-${var.tenant}/hsrpIfPol-${var.name}"
  class_name = "hsrpIfPol"
  content = {
    name  = var.name
    descr = var.description
    ctrl = join(",", concat(
      var.bfd_enable ? ["bfd"] : [],
      var.use_bia ? ["bia"] : []
    ))
    delay       = var.delay
    reloadDelay = var.reload_delay
  }
}