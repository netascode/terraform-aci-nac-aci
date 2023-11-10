resource "aci_rest_managed" "mcpInstPol" {
  dn         = "uni/infra/mcpInstP-default"
  class_name = "mcpInstPol"
  content = {
    adminSt        = var.admin_state == true ? "enabled" : "disabled"
    ctrl           = var.per_vlan == true ? "pdu-per-vlan" : ""
    initDelayTime  = var.initial_delay
    key            = var.key
    loopDetectMult = var.loop_detection
    loopProtectAct = var.disable_port_action == true ? "port-disable" : ""
    txFreq         = var.frequency_sec
    txFreqMsec     = var.frequency_msec
  }

  lifecycle {
    ignore_changes = [content["key"]]
  }
}
