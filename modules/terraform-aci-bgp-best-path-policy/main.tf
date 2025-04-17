resource "aci_rest_managed" "bgpBestPathCtrlPol" {
  dn         = "uni/tn-${var.tenant}/bestpath-${var.name}"
  class_name = "bgpBestPathCtrlPol"
  content = {
    name  = var.name
    descr = var.description
    ctrl  = join(",", concat(var.as_path_multipath_relax == true ? ["asPathMultipathRelax"] : [], var.ignore_igp_metric == true ? ["ignoreIgpMetric"] : []))
  }
}
