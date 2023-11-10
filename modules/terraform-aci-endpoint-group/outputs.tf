output "dn" {
  value       = aci_rest_managed.fvAEPg.id
  description = "Distinguished name of `fvAEPg` object."
}

output "name" {
  value       = aci_rest_managed.fvAEPg.content.name
  description = "Endpoint group name."
}
