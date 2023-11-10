output "dn" {
  value       = aci_rest_managed.snmpGroup.id
  description = "Distinguished name of `snmpGroup` object."
}

output "name" {
  value       = aci_rest_managed.snmpGroup.content.name
  description = "SNMP trap policy name."
}
