output "dn" {
  value       = aci_rest_managed.fabricSpineP.id
  description = "Distinguished name of `fabricSpineP` object."
}

output "name" {
  value       = aci_rest_managed.fabricSpineP.content.name
  description = "Spine switch profile name."
}
