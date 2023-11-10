output "dn" {
  value       = aci_rest_managed.lldpIfPol.id
  description = "Distinguished name of `lldpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.lldpIfPol.content.name
  description = "LLDP interface policy name."
}
