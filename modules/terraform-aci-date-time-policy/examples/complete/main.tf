module "aci_date_time_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-date-time-policy"
  version = ">= 0.8.0"

  name                           = "DATE1"
  apic_ntp_server_master_stratum = 10
  ntp_admin_state                = false
  ntp_auth_state                 = true
  apic_ntp_server_master_mode    = true
  apic_ntp_server_state          = true
  ntp_servers = [{
    hostname_ip   = "100.1.1.1"
    preferred     = true
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
    auth_key_id   = 1
  }]
  ntp_keys = [{
    id        = 1
    key       = "SECRETKEY"
    auth_type = "sha1"
    trusted   = true
  }]
}
