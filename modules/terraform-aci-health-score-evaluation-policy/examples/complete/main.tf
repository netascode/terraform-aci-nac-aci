module "aci_health_score_evaluation_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-health-score-evaluation-policy"
  version = ">= 0.8.0"

  ignore_acked_faults = true
}
