module "aci_vspan_destination_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vspan-destination-group"
  version = ">= 0.8.0"

  name        = "DST_GRP"
  description = "My VSPAN Destination Group"
  destinations = [
    {
      name        = "DST1"
      description = "Destination 1"
      ip          = "1.2.3.4"
      dscp        = "CS4"
      flow_id     = 10
      mtu         = 9000
      ttl         = 10
    },
    {
      name                = "DST2"
      description         = "Destination 2"
      tenant              = "Tenant-1"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      endpoint            = "01:23:45:67:89:AB"
    }
  ]
}
