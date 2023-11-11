module "aci_dns_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-dns-policy"
  version = ">= 0.8.0"

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
