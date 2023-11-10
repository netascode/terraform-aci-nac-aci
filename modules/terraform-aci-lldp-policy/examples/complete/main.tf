module "aci_lldp_policy" {
  source  = "netascode/lldp-policy/aci"
  version = ">= 0.1.0"

  name           = "LLDP-ON"
  admin_rx_state = true
  admin_tx_state = true
}
