output "dn" {
  value       = aci_rest_managed.aaaUser.id
  description = "Distinguished name of `aaaUser` object."
}

output "username" {
  value       = aci_rest_managed.aaaUser.content.name
  description = "Username."
}
