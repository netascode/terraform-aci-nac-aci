output "access_dn" {
  value       = one(aci_rest_managed.infraNodeConfig[*].id)
  description = "Distinguished name of `infraNodeConfig` object."
}

output "fabric_dn" {
  value       = one(aci_rest_managed.fabricNodeConfig[*].id)
  description = "Distinguished name of `fabricNodeConfig` object."
}
