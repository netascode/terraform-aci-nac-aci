output "dn" {
  value       = aci_rest_managed.configExportP.id
  description = "Distinguished name of `configExportP` object."
}

output "name" {
  value       = aci_rest_managed.configExportP.content.name
  description = "Config export policy name."
}
