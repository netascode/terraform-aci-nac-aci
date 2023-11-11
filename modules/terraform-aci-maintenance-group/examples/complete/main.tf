module "aci_maintenance_group" {
  source  = "netascode/maintenance-group/aci"
  version = ">= 0.8.0"

  name     = "UG1"
  node_ids = [101]
}
