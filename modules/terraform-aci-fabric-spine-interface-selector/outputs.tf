output "dn" {
  value       = aci_rest_managed.fabricSFPortS.id
  description = "Distinguished name of `fabricSFPortS` object."
}

output "name" {
  value       = aci_rest_managed.fabricSFPortS.content.name
  description = "Spine interface selector name."
}
