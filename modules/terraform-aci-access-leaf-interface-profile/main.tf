resource "aci_rest_managed" "infraAccPortP" {
  dn         = "uni/infra/accportprof-${var.name}"
  class_name = "infraAccPortP"
  content = {
    name = var.name
  }
}
