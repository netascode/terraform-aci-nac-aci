output "dn" {
  value       = aci_rest_managed.infraSHPortS.id
  description = "Distinguished name of `infraSHPortS` object."
}

output "name" {
  value       = aci_rest_managed.infraSHPortS.content.name
  description = "Spine interface selector name."
}
