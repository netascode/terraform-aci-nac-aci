module "aci_sr_mpls_global_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-sr-mpls-global-configuration"
  version = ">= 0.0.1"

  sr_global_block_minimum = 16000
  sr_global_block_maximum = 275999
}
