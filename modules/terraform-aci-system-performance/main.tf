resource "aci_rest_managed" "commApiRespTime" {
  dn         = "uni/fabric/comm-default/apiResp"
  class_name = "commApiRespTime"
  content = {
    enableCalculation = var.admin_state == true ? "enabled" : "disabled"
    respTimeThreshold = var.response_threshold
    topNRequests      = var.top_slowest_requests
    calcWindow        = var.calculation_window
  }
}