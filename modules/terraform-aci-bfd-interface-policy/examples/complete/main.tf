module "aci_bfd_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bfd-interface-policy"
  version = ">= 0.8.0"

  tenant                    = "ABC"
  name                      = "BFD1"
  description               = "My Description"
  subinterface_optimization = true
  detection_multiplier      = 10
  echo_admin_state          = true
  echo_rx_interval          = 100
  min_rx_interval           = 100
  min_tx_interval           = 100
}
