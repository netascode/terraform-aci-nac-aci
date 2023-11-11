module "aci_maintenance_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-maintenance-group"
  version = ">= 0.8.0"

  name     = "UG1"
  node_ids = [101]
}
