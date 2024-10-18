output "dn" {
  value       = aci_rest_managed.netflowVmmExporterPol.id
  description = "Distinguished name of `netflowVmmExporterPol` object."
}

output "name" {
  value       = aci_rest_managed.netflowVmmExporterPol.content.name
  description = "Netflow VMM Exporter name."
}
