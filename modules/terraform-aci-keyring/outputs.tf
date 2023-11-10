output "dn" {
  value       = aci_rest_managed.pkiKeyRing.id
  description = "Distinguished name of `pkiKeyRing` object."
}

output "name" {
  value       = aci_rest_managed.pkiKeyRing.content.name
  description = "Keyring name."
}
