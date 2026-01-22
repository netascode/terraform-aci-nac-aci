output "dn" {
  value       = aci_rest_managed.l2PortSecurityPol.id
  description = "Distinguished name of `l2PortSecurityPol` object."
}

output "name" {
  value       = aci_rest_managed.l2PortSecurityPol.content.name
  description = "Port security policy name."
}
