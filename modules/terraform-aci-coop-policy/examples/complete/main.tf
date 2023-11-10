module "aci_coop_policy" {
  source  = "netascode/coop-policy/aci"
  version = ">= 0.1.0"

  coop_group_policy = "strict"
}
