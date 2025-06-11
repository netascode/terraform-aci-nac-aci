output "dn" {
  value       = aci_rest_managed.fabricLFPortS.id
  description = "Distinguished name of `fabricLFPortS` object."
}

output "name" {
  value       = aci_rest_managed.fabricLFPortS.content.name
  description = "Leaf interface selector name."
}
