module "aci_bfd_multihop_node_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bfd-multihop-node-policy"
  version = ">= 0.8.0"

  tenant               = "ABC"
  name                 = "BFD-MHOP"
  description          = "My Description"
  detection_multiplier = 10
  min_rx_interval      = 100
  min_tx_interval      = 100
}