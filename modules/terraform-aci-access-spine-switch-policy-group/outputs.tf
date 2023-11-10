output "dn" {
  value       = aci_rest_managed.infraSpineAccNodePGrp.id
  description = "Distinguished name of `infraSpineAccNodePGrp` object."
}

output "name" {
  value       = aci_rest_managed.infraSpineAccNodePGrp.content.name
  description = "Spine switch policy group name."
}
