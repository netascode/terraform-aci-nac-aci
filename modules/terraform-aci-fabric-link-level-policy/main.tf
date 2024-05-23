resource "aci_rest_managed" "fabricFIfPol" {
  dn         = "uni/fabric/fintfpol-${var.name}"
  class_name = "fabricFIfPol"
  content = {
    name         = var.name
    descr        = var.description
    linkDebounce = var.link_debounce_interval
  }
}
