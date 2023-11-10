output "dn" {
  value       = aci_rest_managed.mgmtInB.id
  description = "Distinguished name of `mgmtInB` object."
}

output "name" {
  value       = aci_rest_managed.mgmtInB.content.name
  description = "Inband endpoint group name."
}
