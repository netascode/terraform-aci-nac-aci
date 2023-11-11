module "aci_oob_node_address" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-node-address"
  version = ">= 0.8.0"

  node_id        = 111
  pod_id         = 2
  ip             = "100.1.1.111/24"
  gateway        = "100.1.1.254"
  v6_ip          = "2001::2/64"
  v6_gateway     = "2001::1"
  endpoint_group = "OOB1"
}
