resource "aci_rest_managed" "mcpIfPol" {
  dn         = "uni/infra/mcpIfP-${var.name}"
  class_name = "mcpIfPol"
  content = merge(
    {
      name    = var.name
      adminSt = var.admin_state == true ? "enabled" : "disabled"
    },
    var.per_vlan_mcp != null ? merge(
      { mcpPduPerVlan = var.per_vlan_mcp ? "on" : "off" },
      var.per_vlan_mcp && var.max_vlans != null ? { maxPduPerVlanLimit = var.max_vlans } : {}
    ) : {},
    var.strict_mode != null ? merge(
      { mcpMode = var.strict_mode ? "on" : "off" },
      var.strict_mode && var.grace_period != null ? { gracePeriod = var.grace_period } : {},
      var.strict_mode && var.grace_period_msec != null ? { gracePeriodMsec = var.grace_period_msec } : {},
      var.strict_mode && var.initial_delay != null ? { strictInitDelayTime = var.initial_delay } : {},
      var.strict_mode && var.frequency_sec != null ? { strictTxFreq = var.frequency_sec } : {},
      var.strict_mode && var.frequency_msec != null ? { strictTxFreqMsec = var.frequency_msec } : {}
    ) : {}
  )
}
