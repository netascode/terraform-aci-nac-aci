output "dn" {
  value       = aci_rest_managed.pkiTP.id
  description = "Distinguished name of `pkiTP` object."
}

output "name" {
  value       = aci_rest_managed.pkiTP.content.name
  description = "CA certificate name."
}
