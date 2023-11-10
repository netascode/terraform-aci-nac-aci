output "dn" {
  value       = aci_rest_managed.mgmtOoB.id
  description = "Distinguished name of `mgmtOoB` object."
}

output "name" {
  value       = aci_rest_managed.mgmtOoB.content.name
  description = "OOB endpoint group name."
}
