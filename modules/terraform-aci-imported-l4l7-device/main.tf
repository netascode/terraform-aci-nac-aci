resource "aci_rest_managed" "vnsLDevIf" {
  dn         = "uni/tn-${var.tenant}/lDevIf-[uni/tn-${var.source_tenant}/lDevVip-${var.source_device}]"
  class_name = "vnsLDevIf"
  content = {
    ldev        = "uni/tn-${var.source_tenant}/lDevVip-${var.source_device}"
    description = var.description
  }
}
