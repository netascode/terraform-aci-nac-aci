output "dn" {
  value       = aci_rest_managed.fvEpRetPol.id
  description = "Distinguished name of `fvEpRetPol` object."
}

output "name" {
  value       = aci_rest_managed.fvEpRetPol.content.name
  description = "Endpoint Retention policy name."
}
