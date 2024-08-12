module "aci_access_spine_copp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-copp-policy"
  version = ">= 0.8.0"

  name        = "POL1"
  description = "POL1"
  type        = "custom"
  custom_values = {
    arp_rate      = 1234
    arp_burst     = 300
    acl_log_rate  = 150
    acl_log_burst = 300
  }
}