module "aci_interface_type" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-state"
  version = ">= 0.8.0"

  pod_id   = 1
  node_id  = 101
  module   = 1
  port     = 1
  shutdown = false
}
