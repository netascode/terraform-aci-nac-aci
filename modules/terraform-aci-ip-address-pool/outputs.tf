output "dn" {
  value       = aci_rest_managed.fvnsAddrInst.id
  description = "Distinguished name of `fvnsAddrInst` object."
}

output "name" {
  value       = aci_rest_managed.fvnsAddrInst.content.name
  description = "IP address pool name."
}
