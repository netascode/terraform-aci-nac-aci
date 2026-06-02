resource "aci_rest_managed" "mcpIfPol" {
  dn         = "uni/infra/mcpIfP-${var.name}"
  class_name = "mcpIfPol"
  content = {
    name               = var.name
    adminSt            = var.admin_state == true ? "enabled" : "disabled"
    mcpPduPerVlan      = var.per_vlan_mcp == true ? "on" : "off"
    maxPduPerVlanLimit = var.max_vlans
    # Strict-mode attributes (mcpMode, gracePeriod*, strict*) require APIC >= 5.2.
    # Only emit them when strict_mode = true so older APIC versions are not affected.
    mcpMode             = var.strict_mode ? "on" : null
    gracePeriod         = var.strict_mode ? var.grace_period : null
    gracePeriodMsec     = var.strict_mode ? var.grace_period_msec : null
    strictInitDelayTime = var.strict_mode ? var.strict_init_delay_time : null
    strictTxFreq        = var.strict_mode ? var.strict_tx_freq : null
    strictTxFreqMsec    = var.strict_mode ? var.strict_tx_freq_msec : null
  }
}
