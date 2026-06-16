resource "aci_rest_managed" "mcpIfPol" {
  dn         = "uni/infra/mcpIfP-${var.name}"
  class_name = "mcpIfPol"
  content = {
    name                = var.name
    adminSt             = var.admin_state == true ? "enabled" : "disabled"
    mcpPduPerVlan       = var.per_vlan_mcp == true ? "on" : "off"
    maxPduPerVlanLimit  = var.max_vlans
    mcpMode             = var.strict_mode == null ? null : (var.strict_mode ? "on" : "off")
    gracePeriod         = var.grace_period
    gracePeriodMsec     = var.grace_period_msec
    strictInitDelayTime = var.initial_delay
    strictTxFreq        = var.frequency_sec
    strictTxFreqMsec    = var.frequency_msec
  }
}
