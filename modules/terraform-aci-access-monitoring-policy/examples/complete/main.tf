module "aci_infra_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-monitoring-policy"
  version = ">= 0.8.0"

  name        = "INFRA-MONITORING-POL"
  description = "My Description"
}