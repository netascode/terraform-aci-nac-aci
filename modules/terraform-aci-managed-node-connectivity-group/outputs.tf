output "dn" {
  value       = aci_rest_managed.mgmtGrp.id
  description = "Distinguished name of `mgmtGrp` object."
}

output "name" {
  value       = aci_rest_managed.mgmtGrp.content.name
  description = "Managed node connectivity group name."
}
