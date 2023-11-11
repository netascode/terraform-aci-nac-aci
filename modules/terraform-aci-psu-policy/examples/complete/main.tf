module "aci_psu_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-psu-policy"
  version = ">= 0.8.0"

  name        = "PSU1"
  admin_state = "nnred"
}
