resource "aci_rest_managed" "mcpIfPol" {
  dn         = "uni/infra/mcpIfP-${var.name}"
  class_name = "mcpIfPol"
  content = {
    name               = var.name
    adminSt            = var.admin_state == true ? "enabled" : "disabled"
    mcpPduPerVlan      = var.per_vlan_mcp == true ? "on" : "off"
    mcpMode            = var.strict_mode == true ? "on" : "off"
    maxPduPerVlanLimit = var.max_vlans
    gracePeriod        = var.grace_period
    gracePeriodMsec    = var.grace_period_msec
  }
}
