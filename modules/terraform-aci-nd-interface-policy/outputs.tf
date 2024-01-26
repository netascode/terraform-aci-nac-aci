output "dn" {
  value       = aci_rest_managed.ndIfPol.id
  description = "Distinguished name of `ndIfPol` object."
}

output "name" {
  value       = aci_rest_managed.ndIfPol.content.name
  description = "ND interface policy name."
}
