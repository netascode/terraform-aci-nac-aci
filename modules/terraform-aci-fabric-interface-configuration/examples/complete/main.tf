module "aci_fabric_interface_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-interface-configuration"
  version = ">= 0.8.0"

  node_id      = 101
  policy_group = "FAB1"
  description  = "Port description"
  port         = 49
}
