resource "aci_rest_managed" "monInfraPol" {
  dn         = "uni/infra/moninfra-${var.name}"
  class_name = "monInfraPol"
  content = {
    name  = var.name
    descr = var.description
  }
}
