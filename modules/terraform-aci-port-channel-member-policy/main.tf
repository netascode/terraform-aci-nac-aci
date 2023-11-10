resource "aci_rest_managed" "lacpIfPol" {
  dn         = "uni/infra/lacpifp-${var.name}"
  class_name = "lacpIfPol"
  content = {
    name   = var.name
    prio   = var.priority
    txRate = var.rate
  }
}
