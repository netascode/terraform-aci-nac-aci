output "dn" {
  value       = aci_rest_managed.vnsSvcEPgPol.id
  description = "Distinguished name of `vnsSvcEPgPol` object."
}

output "name" {
  value       = aci_rest_managed.vnsSvcEPgPol.content.name
  description = "Service EPG policy name."
}
