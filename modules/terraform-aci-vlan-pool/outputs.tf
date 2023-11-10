output "dn" {
  value       = aci_rest_managed.fvnsVlanInstP.id
  description = "Distinguished name of `fvnsVlanInstP` object."
}

output "name" {
  value       = aci_rest_managed.fvnsVlanInstP.content.name
  description = "Vlan pool name."
}
