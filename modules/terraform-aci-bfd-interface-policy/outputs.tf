output "dn" {
  value       = aci_rest_managed.bfdIfPol.id
  description = "Distinguished name of `bfdIfPol` object."
}

output "name" {
  value       = aci_rest_managed.bfdIfPol.content.name
  description = "BFD interface policy name."
}
