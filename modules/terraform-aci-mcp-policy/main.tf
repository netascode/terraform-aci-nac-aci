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
      var.per_vlan_mcp ? { maxPduPerVlanLimit = tostring(var.max_vlans) } : {}
    ) : {},
    var.strict_mode != null ? merge(
      { mcpMode = var.strict_mode ? "on" : "off" },
      var.strict_mode ? {
        gracePeriod         = tostring(var.grace_period)
        gracePeriodMsec     = tostring(var.grace_period_msec)
        strictInitDelayTime = tostring(var.initial_delay)
        strictTxFreq        = tostring(var.frequency_sec)
        strictTxFreqMsec    = tostring(var.frequency_msec)
      } : {}
    ) : {}
  )
}
