output "dn" {
  value       = aci_rest_managed.fabricNodeIdentP.id
  description = "Distinguished name of `fabricNodeIdentP` object."
}

output "name" {
  value       = aci_rest_managed.fabricNodeIdentP.content.name
  description = "Node name."
}
