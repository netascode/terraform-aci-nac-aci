module "aci_dns_policy" {
  source  = "netascode/dns-policy/aci"
  version = ">= 0.2.0"

  name          = "DNS1"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
  providers_ = [{
    ip        = "10.1.1.1"
    preferred = true
  }]
  domains = [{
    name    = "cisco.com"
    default = true
  }]
}
