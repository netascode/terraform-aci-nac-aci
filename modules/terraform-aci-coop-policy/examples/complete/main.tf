module "aci_coop_policy" {
  source  = "netascode/coop-policy/aci"
  version = ">= 0.8.0"

  coop_group_policy = "strict"
}
