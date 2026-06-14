module "aci_tacacs_monitoring_destination" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination"
  version = ">= 0.8.0"

  name        = "TACACS_MON1"
  description = "My Description"
  destinations = [{
    name          = "DEST1"
    host          = "1.1.1.1"
    port          = 49
    auth_protocol = "pap"
    key           = "cisco123"
    description   = "Primary TACACS Destination"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    }, {
    name              = "DEST2"
    host              = "2.2.2.2"
    port              = 49
    auth_protocol     = "chap"
    populate_cmd_args = true
    mgmt_epg_type     = "inb"
    mgmt_epg_name     = "INB1"
  }]
}
