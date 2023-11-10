resource "aci_rest_managed" "stormctrlIfPol" {
  dn         = "uni/infra/stormctrlifp-${var.name}"
  class_name = "stormctrlIfPol"
  content = {
    name                     = var.name
    nameAlias                = var.alias
    descr                    = var.description
    stormCtrlAction          = var.action
    type                     = "all"
    isUcMcBcStormPktCfgValid = "Valid"
    burstPps                 = "unspecified"
    burstRate                = "100.000000"
    rate                     = "100.000000"
    ratePps                  = "unspecified"
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
