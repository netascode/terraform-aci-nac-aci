module "aci_storm_control_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-storm-control-policy"
  version = ">= 0.8.0"

  name                       = "SC1"
  alias                      = "SC1-ALIAS"
  description                = "My Description"
  action                     = "shutdown"
  broadcast_burst_pps        = "1000"
  broadcast_burst_rate       = "10.000000"
  broadcast_pps              = "1000"
  broadcast_rate             = "10.000000"
  multicast_burst_pps        = "1000"
  multicast_burst_rate       = "10.000000"
  multicast_pps              = "1000"
  multicast_rate             = "10.000000"
  unknown_unicast_burst_pps  = "1000"
  unknown_unicast_burst_rate = "10.000000"
  unknown_unicast_pps        = "1000"
  unknown_unicast_rate       = "10.000000"
}
