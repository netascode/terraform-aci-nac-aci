module "aci_link_level_policy" {
  source  = "netascode/link-level-policy/aci"
  version = ">= 0.8.0"

  name     = "100G"
  speed    = "100G"
  auto     = true
  fec_mode = "disable-fec"
}
