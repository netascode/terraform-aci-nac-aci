output "dn" {
  value       = aci_rest_managed.fabricPodPGrp.id
  description = "Distinguished name of `fabricPodPGrp` object."
}

output "name" {
  value       = aci_rest_managed.fabricPodPGrp.content.name
  description = "Pod policy group name."
}
