module "aci_access_span_destination_group-destination_epg" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name                = "ABC"
  ip                  = "1.1.1.1"
  source_prefix       = "2.2.2.2"
  dscp                = "CS0"
  mtu                 = 9000
  ttl                 = 16
  span_version        = 2
  enforce_version     = true
  tenant              = "TEN1"
  application_profile = "APP1"
  endpoint_group      = "EPG1"
}

module "aci_access_span_destination_group-destination_port" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name    = "ABC"
  mtu     = 9000
  pod_id  = 2
  node_id = 101
  module  = 2
  port    = 10
}

module "aci_access_span_destination_group-destination_subport" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name     = "ABC"
  mtu      = 9000
  pod_id   = 2
  node_id  = 101
  module   = 2
  port     = 10
  sub_port = 5
}


module "aci_access_span_destination_group-destination_channel" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-destination-group"
  version = ">= 0.8.0"

  name    = "ABC"
  mtu     = 9000
  node_id = 101
  channel = "PC1"
}


