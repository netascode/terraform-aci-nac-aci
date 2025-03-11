resource "aci_rest_managed" "stormctrlIfPol" {
  dn         = "uni/infra/stormctrlifp-${var.name}"
  class_name = "stormctrlIfPol"
  content = {
    name                     = var.name
    nameAlias                = var.alias
    descr                    = var.description
    stormCtrlAction          = var.action
    type                     = "all"
    isUcMcBcStormPktCfgValid = var.configuration_type == "separate" ? "Valid" : "Invalid"
    burstPps                 = var.burst_pps
    burstRate                = format("%.6f", var.burst_rate)
    rate                     = format("%.6f", var.rate)
    ratePps                  = var.rate_pps
    stormCtrlSoakInstCount   = "3"
    bcBurstPps               = var.broadcast_burst_pps
    bcBurstRate              = format("%.6f", var.broadcast_burst_rate)
    bcRatePps                = var.broadcast_pps
    bcRate                   = format("%.6f", var.broadcast_rate)
    mcBurstPps               = var.multicast_burst_pps
    mcBurstRate              = format("%.6f", var.multicast_burst_rate)
    mcRatePps                = var.multicast_pps
    mcRate                   = format("%.6f", var.multicast_rate)
    uucBurstPps              = var.unknown_unicast_burst_pps
    uucBurstRate             = format("%.6f", var.unknown_unicast_burst_rate)
    uucRatePps               = var.unknown_unicast_pps
    uucRate                  = format("%.6f", var.unknown_unicast_rate)
  }
}
