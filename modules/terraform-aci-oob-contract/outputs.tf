output "dn" {
  value       = aci_rest_managed.vzOOBBrCP.id
  description = "Distinguished name of `vzOOBBrCP` object."
}

output "name" {
  value       = aci_rest_managed.vzOOBBrCP.content.name
  description = "OOB contract name."
}
