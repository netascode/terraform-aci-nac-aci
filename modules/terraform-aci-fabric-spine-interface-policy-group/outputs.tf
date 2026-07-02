output "dn" {
  value       = aci_rest_managed.fabricSpPortPGrp.id
  description = "Distinguished name of `fabricSpPortPGrp` object."
}

output "name" {
  value       = aci_rest_managed.fabricSpPortPGrp.content.name
  description = "Spine interface policy group name."
}
