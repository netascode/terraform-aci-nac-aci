output "dn" {
  value       = aci_rest_managed.physDomP.id
  description = "Distinguished name of `physDomP` object."
}

output "name" {
  value       = aci_rest_managed.physDomP.content.name
  description = "Physical domain name."
}
