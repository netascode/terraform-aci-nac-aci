module "aci_bfd_multihop_node_policy" {
  source  = "netascode/bfd-multihop-node-policy/aci"
  version = ">= 0.1.0"

  tenant               = "ABC"
  name                 = "BFD-MHOP"
  description          = "My Description"
  detection_multiplier = 10
  min_rx_interval      = 100
  min_tx_interval      = 100
}