module "aci_cdp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-cdp-policy"
  version = ">= 0.8.0"

  name        = "CDP1"
  admin_state = true
}
