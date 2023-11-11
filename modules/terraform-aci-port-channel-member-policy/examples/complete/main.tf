module "aci_port_channel_member_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-channel-member-policy"
  version = ">= 0.8.0"

  name     = "FAST"
  priority = 10
  rate     = "fast"
}
