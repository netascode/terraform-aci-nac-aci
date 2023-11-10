output "dn" {
  value       = aci_rest_managed.fvBD.id
  description = "Distinguished name of `fvBD` object."
}

output "name" {
  value       = aci_rest_managed.fvBD.content.name
  description = "Bridge domain name."
}
