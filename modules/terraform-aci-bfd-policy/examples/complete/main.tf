module "aci_bfd_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bfd-policy"
  version = ">= 0.8.0"

  name                   = "BFD-IPV4-POLICY"
  type                   = "ipv4"
  description            = "BFD IPv4 Policy"
  detection_multiplier   = 3
  min_rx_interval        = 50
  min_tx_interval        = 50
  slow_timer_interval    = 2000
  startup_timer_interval = 10
  echo_rx_interval       = 50
}
