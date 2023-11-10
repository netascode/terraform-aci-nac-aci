module "aci_psu_policy" {
  source  = "netascode/psu-policy/aci"
  version = ">= 0.1.0"

  name        = "PSU1"
  admin_state = "nnred"
}
