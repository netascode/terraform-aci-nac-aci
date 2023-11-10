resource "aci_rest_managed" "bgpBestPathCtrlPol" {
  dn         = "uni/tn-${var.tenant}/bestpath-${var.name}"
  class_name = "bgpBestPathCtrlPol"
  content = {
    name  = var.name
    descr = var.description
    ctrl  = var.control_type == "multi-path-relax" ? "asPathMultipathRelax" : ""
  }
}
