module "aci_config_export" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-config-export"
  version = ">= 0.8.0"

  name            = "EXP1"
  description     = "My Description"
  format          = "xml"
  snapshot        = true
  remote_location = "REMOTE1"
  scheduler       = "SCHEDULER1"
}
