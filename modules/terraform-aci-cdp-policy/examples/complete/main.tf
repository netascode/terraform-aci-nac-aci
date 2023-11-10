module "aci_cdp_policy" {
  source  = "netascode/cdp-policy/aci"
  version = ">= 0.1.0"

  name        = "CDP1"
  admin_state = true
}
