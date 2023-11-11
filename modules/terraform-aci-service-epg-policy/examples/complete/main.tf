module "aci_service_epg_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-service-epg-policy"
  version = ">= 0.8.0"

  tenant          = "ABC"
  name            = "SERVICE_EPG_POLICY_1"
  description     = "My Description"
  preferred_group = true
}
