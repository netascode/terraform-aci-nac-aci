output "dn" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.id
  description = "Distinguished name of `fvIPSLAMonitoringPol` object."
}

output "name" {
  value       = aci_rest_managed.fvIPSLAMonitoringPol.content.name
  description = "IP SLA Policy name."
}
