module "aci_tacacs_monitoring_destination" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination"
  version = ">= 0.8.0"

  name        = "TACACS_MON1"
  description = "My Description"
  destinations = [{
    hostname_ip   = "1.1.1.1"
    port          = 49
    protocol      = "pap"
    key           = "cisco123"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    }, {
    hostname_ip   = "2.2.2.2"
    port          = 49
    protocol      = "chap"
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
  }]
}
