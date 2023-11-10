module "aci_service_epg_policy" {
  source  = "netascode/service-epg-policy/aci"
  version = ">= 0.1.0"

  tenant          = "ABC"
  name            = "SERVICE_EPG_POLICY_1"
  description     = "My Description"
  preferred_group = true
}
