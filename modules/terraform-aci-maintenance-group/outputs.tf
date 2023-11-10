output "dn" {
  value       = aci_rest_managed.maintMaintGrp.id
  description = "Distinguished name of `maintMaintGrp` object."
}

output "name" {
  value       = aci_rest_managed.maintMaintGrp.content.name
  description = "Maintenance group name."
}
