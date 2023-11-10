output "dn" {
  value       = aci_rest_managed.vzBrCP.id
  description = "Distinguished name of `vzBrCP` object."
}

output "name" {
  value       = aci_rest_managed.vzBrCP.content.name
  description = "Contract name."
}
