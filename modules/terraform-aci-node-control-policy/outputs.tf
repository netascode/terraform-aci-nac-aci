output "dn" {
  value       = aci_rest_managed.fabricNodeControl.id
  description = "Distinguished name of `fabricNodeControl` object."
}

output "name" {
  value       = aci_rest_managed.fabricNodeControl.content.name
  description = "Node control policy name."
}
