output "dn" {
  value       = aci_rest_managed.infraSpineP.id
  description = "Distinguished name of `infraSpineP` object."
}

output "name" {
  value       = aci_rest_managed.infraSpineP.content.name
  description = "Spine switch profile name."
}
