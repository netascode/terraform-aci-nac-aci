module "aci_snmp_trap_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-snmp-trap-policy"
  version = ">= 0.8.0"

  name        = "TRAP1"
  description = "My Description"
  destinations = [{
    hostname_ip   = "1.1.1.1"
    port          = 1162
    community     = "COM1"
    security      = "priv"
    version       = "v3"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
  }]
}
