resource "aci_rest_managed" "infraSpAccPortP" {
  dn         = "uni/infra/spaccportprof-${var.name}"
  class_name = "infraSpAccPortP"
  content = {
    name = var.name
  }
}
