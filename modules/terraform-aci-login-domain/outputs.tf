output "dn" {
  value       = aci_rest_managed.aaaLoginDomain.id
  description = "Distinguished name of `aaaLoginDomain` object."
}

output "name" {
  value       = aci_rest_managed.aaaLoginDomain.content.name
  description = "Login domain name."
}
