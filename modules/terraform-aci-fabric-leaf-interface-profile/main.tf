resource "aci_rest_managed" "fabricLePortP" {
  dn         = "uni/fabric/leportp-${var.name}"
  class_name = "fabricLePortP"
  content = {
    name = var.name
  }
}
