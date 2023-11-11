module "aci_error_disabled_recovery" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-error-disabled-recovery"
  version = ">= 0.8.0"

  interval   = 600
  mcp_loop   = true
  ep_move    = true
  bpdu_guard = true
}
