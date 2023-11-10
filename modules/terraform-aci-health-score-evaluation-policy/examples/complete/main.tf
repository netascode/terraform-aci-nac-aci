module "aci_health_score_evaluation_policy" {
  source  = "netascode/health-score-evaluation-policy/aci"
  version = ">= 0.1.0"

  ignore_acked_faults = true
}
