output "dn" {
  value       = aci_rest_managed.commPol.id
  description = "Distinguished name of `commPol` object."
}

output "name" {
  value       = aci_rest_managed.commPol.content.name
  description = "Management access policy name."
}
