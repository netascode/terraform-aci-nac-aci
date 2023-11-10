module "aci_tacacs" {
  source  = "netascode/tacacs/aci"
  version = ">= 0.1.0"

  hostname_ip         = "1.1.1.1"
  description         = "My Description"
  protocol            = "chap"
  monitoring          = true
  monitoring_username = "USER1"
  monitoring_password = "PASSWORD1"
  key                 = "ABCDEFGH"
  port                = 149
  retries             = 3
  timeout             = 10
  mgmt_epg_type       = "oob"
  mgmt_epg_name       = "OOB1"
}
