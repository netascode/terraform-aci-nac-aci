module "aci_coop_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-coop-policy"
  version = ">= 0.8.0"

  coop_group_policy = "strict"
}
