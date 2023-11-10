module "aci_config_export" {
  source  = "netascode/config-export/aci"
  version = ">= 0.1.0"

  name            = "EXP1"
  description     = "My Description"
  format          = "xml"
  snapshot        = true
  remote_location = "REMOTE1"
  scheduler       = "SCHEDULER1"
}
