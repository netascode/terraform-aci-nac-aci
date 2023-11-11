module "aci_fabric_wide_settings" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-wide-settings"
  version = ">= 0.8.0"

  domain_validation             = true
  enforce_subnet_check          = true
  opflex_authentication         = false
  disable_remote_endpoint_learn = true
  overlapping_vlan_validation   = true
  remote_leaf_direct            = true
}
