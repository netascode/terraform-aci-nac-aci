resource "aci_rest_managed" "infraCPMtuPol" {
  dn         = "uni/infra/CPMtu"
  class_name = "infraCPMtuPol"
  content = {
    cpMTU        = var.CPMtu
    apicMtuApply = var.APICMtuApply
  }
}
