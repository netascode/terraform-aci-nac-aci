module "aci_dhcp_relay_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-dhcp-relay-policy"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "DHCP-RELAY1"
  description = "My Description"
  providers_ = [{
    ip                  = "10.1.1.1"
    type                = "epg"
    tenant              = "ABC"
    application_profile = "AP1"
    endpoint_group      = "EPG1"
  }]
}
