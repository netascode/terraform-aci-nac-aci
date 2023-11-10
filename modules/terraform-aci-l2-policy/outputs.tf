output "dn" {
  value       = aci_rest_managed.l2IfPol.id
  description = "Distinguished name of `l2IfPol` object."
}

output "name" {
  value       = aci_rest_managed.l2IfPol.content.name
  description = "L2 interface policy name."
}
