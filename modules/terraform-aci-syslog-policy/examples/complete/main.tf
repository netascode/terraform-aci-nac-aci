module "aci_syslog_policy" {
  source  = "netascode/syslog-policy/aci"
  version = ">= 0.2.1"

  name                = "SYSLOG1"
  description         = "My Description"
  format              = "nxos"
  show_millisecond    = true
  admin_state         = true
  local_admin_state   = false
  local_severity      = "errors"
  console_admin_state = false
  console_severity    = "critical"
  destinations = [{
    name          = "DEST1"
    hostname_ip   = "1.1.1.1"
    protocol      = "tcp"
    port          = 1514
    admin_state   = false
    format        = "nxos"
    facility      = "local1"
    severity      = "information"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
  }]
}
