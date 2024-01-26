output "dn" {
  value       = aci_rest_managed.fabricHIfPol[0].id
  description = "Distinguished name of `fabricHIfPol` object."
}

output "name" {
  value       = aci_rest_managed.fabricHIfPol[0].content.name
  description = "Link level interface policy name."
}
