module "aci_tenant_span_destination_group" {
  source  = "netascode/tenant-span-destination-group/aci"
  version = ">= 0.1.0"

  tenant                          = "TF"
  name                            = "DST_GRP"
  description                     = "My Tenant SPAN Destination Group"
  destination_tenant              = "ABC"
  destination_application_profile = "AP1"
  destination_endpoint_group      = "EPG1"
  ip                              = "1.1.1.1"
  source_prefix                   = "1.2.3.4/32"
  dscp                            = "CS4"
  flow_id                         = 10
  mtu                             = 9000
  ttl                             = 10
  span_version                    = 2
  enforce_version                 = true
}
