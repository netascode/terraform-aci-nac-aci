module "aci_system_global_gipo" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-system-global-gipo"
  version = ">= 0.8.0"

  use_infra_gipo = true
}
