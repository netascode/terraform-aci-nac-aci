output "dn" {
  value       = aci_rest_managed.infraAttEntityP.id
  description = "Distinguished name of `infraAttEntityP` object."
}

output "name" {
  value       = aci_rest_managed.infraAttEntityP.content.name
  description = "AAEP name."
}
