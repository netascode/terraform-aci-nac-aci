output "dn" {
  value       = aci_rest_managed.eigrpIfPol.id
  description = "Distinguished name of `eigrpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.eigrpIfPol.content.name
  description = "EIGRP interface policy name."
}
