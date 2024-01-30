module "aci_switch_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-switch-configuration"
  version = ">= 0.8.0"

  node_id             = 101
  role                = "leaf"
  access_policy_group = "LFACC1"
  fabric_policy_group = "LFFAB1"
}
