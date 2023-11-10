output "dn" {
  value       = aci_rest_managed.fvAp.id
  description = "Distinguished name of `fvAp` object."
}

output "name" {
  value       = aci_rest_managed.fvAp.content.name
  description = "Application profile name."
}
