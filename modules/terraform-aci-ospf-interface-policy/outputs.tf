output "dn" {
  value       = aci_rest_managed.ospfIfPol.id
  description = "Distinguished name of `ospfIfPol` object."
}

output "name" {
  value       = aci_rest_managed.ospfIfPol.content.name
  description = "OSPF interface policy name."
}
