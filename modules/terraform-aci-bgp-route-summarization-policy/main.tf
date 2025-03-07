resource "aci_rest_managed" "bgpRtSummPol" {
  dn         = "uni/tn-${var.tenant}/bgprtsum-${var.name}"
  class_name = "bgpRtSummPol"
  content = {
    name      = var.name
    descr     = var.description
    ctrl      = join(",", concat(var.as_set == true ? ["as-set"] : [], var.summary_only == true ? ["summary-only"] : []))
    addrTCtrl = join(",", concat(var.af_mcast == true ? ["af-mcast"] : [], var.af_ucast == true ? ["af-ucast"] : [])) == "af-ucast" ? null : join(",", concat(var.af_mcast == true ? ["af-mcast"] : [], var.af_ucast == true ? ["af-ucast"] : []))
  }
}