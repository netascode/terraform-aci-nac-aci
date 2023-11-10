resource "aci_rest_managed" "fabricSpPortP" {
  dn         = "uni/fabric/spportp-${var.name}"
  class_name = "fabricSpPortP"
  content = {
    name = var.name
  }
}
