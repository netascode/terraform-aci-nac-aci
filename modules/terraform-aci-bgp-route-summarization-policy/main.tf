locals {
  addrTCtrl = length(join(",", concat(var.af_mcast == true ? ["af-mcast"] : [], var.af_ucast == true ? ["af-ucast"] : []))) > 0 ? join(",", concat(var.af_mcast == true ? ["af-mcast"] : [], var.af_ucast == true ? ["af-ucast"] : [])) : null
}
variable "content_map" {
  type    = map(string)
  default = {}
}
resource "aci_rest_managed" "bgpRtSummPol" {

  dn         = "uni/tn-${var.tenant}/bgprtsum-${var.name}"
  class_name = "bgpRtSummPol"
  content = merge(
    var.content_map,
    {
      name  = var.name,
      descr = var.description,
      ctrl  = join(",", concat(var.as_set == true ? ["as-set"] : [], var.summary_only == true ? ["summary-only"] : []))
    },
    local.addrTCtrl != null ? { addrTCtrl = local.addrTCtrl } : {}
  )

} 
