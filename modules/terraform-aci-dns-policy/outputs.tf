output "dn" {
  value       = aci_rest_managed.dnsProfile.id
  description = "Distinguished name of `dnsProfile` object."
}

output "name" {
  value       = aci_rest_managed.dnsProfile.content.name
  description = "DNS policy name."
}
