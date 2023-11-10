output "dn" {
  value       = aci_rest_managed.snmpPol.id
  description = "Distinguished name of `snmpPol` object."
}

output "name" {
  value       = aci_rest_managed.snmpPol.content.name
  description = "SNMP policy name."
}
