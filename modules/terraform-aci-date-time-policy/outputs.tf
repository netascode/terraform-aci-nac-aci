output "dn" {
  value       = aci_rest_managed.datetimePol.id
  description = "Distinguished name of `datetimePol` object."
}

output "name" {
  value       = aci_rest_managed.datetimePol.content.name
  description = "Date time policy name."
}
