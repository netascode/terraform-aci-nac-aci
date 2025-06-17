output "dn" {
  value       = aci_rest_managed.fabricLePortPGrp.id
  description = "Distinguished name of `fabricLePortPGrp` object."
}

output "name" {
  value       = aci_rest_managed.fabricLePortPGrp.content.name
  description = "Leaf interface policy group name."
}
