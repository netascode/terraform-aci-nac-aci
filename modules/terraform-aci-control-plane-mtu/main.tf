resource "aci_rest_managed" "infraCPMtuPol" {
  dn         = "uni/infra/CPMtu"
  class_name = "infraCPMtuPol"
  content = {
    cpMTU        = var.control_plane_mtu
    apicMtuApply = var.apic_mtu_apply
  }
}
