output "dn" {
  value       = aci_rest_managed.fvTenant.id
  description = "Distinguished name of `fvTenant` object."
}

output "name" {
  value       = aci_rest_managed.fvTenant.content.name
  description = "Tenant name."
}
