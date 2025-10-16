resource "aci_rest_managed" "fvIPSLAMonitoringPol" {
  dn         = "uni/tn-${var.tenant}/ipslaMonitoringPol-${var.name}"
  class_name = "fvIPSLAMonitoringPol"
  content = {
    name                = var.name
    descr               = var.description
    slaDetectMultiplier = var.multiplier
    slaFrequency        = var.frequency
    slaPort             = var.port
    slaType             = var.sla_type
    httpMethod          = var.http_method
    httpVersion         = var.http_version
    httpUri             = var.http_uri
  }
}
