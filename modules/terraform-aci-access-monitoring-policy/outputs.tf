output "dn" {
  description = "Distinguished name of `monInfraPol` object."
  value       = try(aci_rest_managed.monInfraPol.id, "")
}

output "name" {
  description = "Access monitoring policy name."
  value       = try(aci_rest_managed.monInfraPol.content.name, "")
}
