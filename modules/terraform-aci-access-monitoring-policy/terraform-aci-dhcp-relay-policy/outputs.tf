output "dn" {
  value       = aci_rest_managed.monInfraPol.id
  description = "Distinguished name of `monInfraPol` object."
}

output "name" {
  value       = aci_rest_managed.monInfraPol.content.name
  description = "Monitoring policy name."
}