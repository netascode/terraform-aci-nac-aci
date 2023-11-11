module "aci_lldp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-lldp-policy"
  version = ">= 0.8.0"

  name           = "LLDP-ON"
  admin_rx_state = true
  admin_tx_state = true
}
