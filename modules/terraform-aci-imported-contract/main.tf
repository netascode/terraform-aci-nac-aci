resource "aci_rest_managed" "vzCPIf" {
  dn         = "uni/tn-${var.tenant}/cif-${var.name}"
  class_name = "vzCPIf"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "vzRsIf" {
  dn         = "${aci_rest_managed.vzCPIf.dn}/rsif"
  class_name = "vzRsIf"
  content = {
    tDn = "uni/tn-${var.source_tenant}/brc-${var.source_contract}"
  }
}
