output "dn" {
  value       = aci_rest_managed.mgmtInstP.id
  description = "Distinguished name of `mgmtInstP` object."
}

output "name" {
  value       = aci_rest_managed.mgmtInstP.content.name
  description = "OOB external management instance name."
}
