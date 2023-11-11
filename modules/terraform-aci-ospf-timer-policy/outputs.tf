output "dn" {
  value       = aci_rest_managed.ospfCtxPol.id
  description = "Distinguished name of `ospfCtxPol` object."
}

output "name" {
  value       = aci_rest_managed.ospfCtxPol.content.name
  description = "OSPF timer policy name."
}
