output "dn" {
  value       = aci_rest_managed.netflowExporterPol.id
  description = "Distinguished name of `netflowExporterPol` object."
}

output "name" {
  value       = aci_rest_managed.netflowExporterPol.content.name
  description = "Netflow Exporter name."
}
