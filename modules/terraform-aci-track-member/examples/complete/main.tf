module "aci_track_member" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-track-member"
  version = ">= 0.8.0"

  tenant         = "ABC"
  name           = "MEMBER1"
  description    = "My Description"
  destination_ip = "1.2.3.4"
  scope_type     = "l3out"
  scope          = "L3OUT1"
  ip_sla_policy  = "EXAMPLE"
}
