module "aci_interface_type" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-type"
  version = ">= 0.8.0"

  pod_id  = 2
  node_id = 101
  module  = 2
  port    = 1
  type    = "downlink"
}
