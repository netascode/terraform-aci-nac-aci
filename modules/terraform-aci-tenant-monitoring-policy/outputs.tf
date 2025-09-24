output "dn" {
  value       = aci_rest_managed.monEPGPol.id
  description = "Distinguished name of Tenant `monEPGPol` object."
}

output "name" {
  value       = aci_rest_managed.monEPGPol.content.name
  description = "Tenant Monitoring Policy name."
}
