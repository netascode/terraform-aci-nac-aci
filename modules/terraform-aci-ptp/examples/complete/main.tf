module "aci_ptp" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ptp"
  version = ">= 0.8.0"

  admin_state       = true
  global_domain     = 0
  profile           = "aes67"
  announce_interval = 1
  announce_timeout  = 3
  sync_interval     = -3
  delay_interval    = -2
}
