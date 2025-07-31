resource "aci_rest_managed" "infraCPMtuPol" {
  dn         = "uni/infra/CPMtu"
  class_name = "infraCPMtuPol"
  content = {
    CPMtu        = var.control_plane_mtu
    APICMtuApply = var.apic_mtu_apply
  }
}
