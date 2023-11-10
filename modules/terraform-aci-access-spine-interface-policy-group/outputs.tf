output "dn" {
  value       = aci_rest_managed.infraSpAccPortGrp.id
  description = "Distinguished name of `infraSpAccPortGrp` object."
}

output "name" {
  value       = aci_rest_managed.infraSpAccPortGrp.content.name
  description = "Spine interface policy group name."
}
