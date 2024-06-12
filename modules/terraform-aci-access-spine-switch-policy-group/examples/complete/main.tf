module "aci_access_spine_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-switch-policy-group"
  version = ">= 0.8.0"

  name            = "SW-PG1"
  lldp_policy     = "LLDP-ON"
  bfd_ipv4_policy = "BFD-IPV4-POLICY"
  bfd_ipv6_policy = "BFD-IPV6-POLICY"
}
