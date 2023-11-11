module "system_performance" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-system-performance"
  version = ">= 0.8.0"

  admin_state          = true
  response_threshold   = 8500
  top_slowest_requests = 5
  calculation_window   = 300
}
