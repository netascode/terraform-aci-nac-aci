output "dn" {
  value       = aci_rest_managed.fabricLeNodePGrp.id
  description = "Distinguished name of `fabricLeNodePGrp` object."
}

output "name" {
  value       = aci_rest_managed.fabricLeNodePGrp.content.name
  description = "Leaf switch policy group name."
}
