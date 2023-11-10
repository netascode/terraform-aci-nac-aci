output "dn" {
  value       = aci_rest_managed.syslogGroup.id
  description = "Distinguished name of `syslogGroup` object."
}

output "name" {
  value       = aci_rest_managed.syslogGroup.content.name
  description = "Syslog policy name."
}
