module "aci_link_level_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-link-level-policy"
  version = ">= 0.8.0"

  name             = "100G"
  speed            = "100G"
  link_delay_ms    = 10
  link_debounce_ms = 110
  auto             = true
  fec_mode         = "disable-fec"
}
