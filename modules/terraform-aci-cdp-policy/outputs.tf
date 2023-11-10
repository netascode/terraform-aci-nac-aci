output "dn" {
  value       = aci_rest_managed.cdpIfPol.id
  description = "Distinguished name of `cdpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.cdpIfPol.content.name
  description = "CDP interface policy name."
}
