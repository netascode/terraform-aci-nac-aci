module "aci_interface_type" {
  source  = "netascode/interface-type/aci"
  version = ">= 0.1.0"

  pod_id  = 2
  node_id = 101
  module  = 2
  port    = 1
  type    = "downlink"
}
