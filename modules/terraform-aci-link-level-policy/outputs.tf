output "dn" {
  value       = aci_rest_managed.fabricHIfPol.id
  description = "Distinguished name of `fabricHIfPol` object."
}

output "name" {
  value       = aci_rest_managed.fabricHIfPol.content.name
  description = "Link level interface policy name."
}
