output "dn" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.id
  description = "Distinguished name of `fvIPSLAMonitoringPol` object."
}

output "name" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.name
  description = "IP SLA Policy name."
}

output "sla_type" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.slaType
  description = "IP SLA Policy type."
}

output "http_method" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.httpMethod
  description = "IP SLA Policy HTTP method."
}

output "http_version" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.httpVersion
  description = "IP SLA Policy HTTP version."
}

output "http_uri" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.httpUri
  description = "IP SLA Policy HTTP URI."
}
