module "aci_fabric_span_destination_group" {
  source  = "netascode/fabric-span-destination-group/aci"
  version = ">= 0.1.0"

  name                = "DST_GRP"
  description         = "My Fabric SPAN Destination Group"
  tenant              = "ABC"
  application_profile = "AP1"
  endpoint_group      = "EPG1"
  ip                  = "1.1.1.1"
  source_prefix       = "1.2.3.4/32"
  dscp                = "CS4"
  flow_id             = 10
  mtu                 = 9000
  ttl                 = 10
  span_version        = 2
  enforce_version     = true
}