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
    burstRate                = var.burst_rate
    rate                     = var.rate
    ratePps                  = var.rate_pps
    stormCtrlSoakInstCount   = "3"
    bcBurstPps               = var.broadcast_burst_pps
    bcBurstRate              = var.broadcast_burst_rate
    bcRatePps                = var.broadcast_pps
    bcRate                   = var.broadcast_rate
    mcBurstPps               = var.multicast_burst_pps
    mcBurstRate              = var.multicast_burst_rate
    mcRatePps                = var.multicast_pps
    mcRate                   = var.multicast_rate
    uucBurstPps              = var.unknown_unicast_burst_pps
    uucBurstRate             = var.unknown_unicast_burst_rate
    uucRatePps               = var.unknown_unicast_pps
    uucRate                  = var.unknown_unicast_rate
  }
}
