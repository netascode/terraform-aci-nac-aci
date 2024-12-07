module "aci_interface_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-interface-configuration"
  version = ">= 0.8.0"

  node_id                    = 101
  policy_group               = "ACC1"
  description                = "Port description"
  port                       = 10
  port_channel_member_policy = "FAST"
}
