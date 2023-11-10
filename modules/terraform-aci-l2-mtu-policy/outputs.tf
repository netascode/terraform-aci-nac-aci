output "dn" {
  value       = aci_rest_managed.l2InstPol.id
  description = "Distinguished name of `l2InstPol` object."
}

output "name" {
  value       = aci_rest_managed.l2InstPol.content.name
  description = "MTU policy name."
}