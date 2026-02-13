output "dn" {
  value       = aci_rest_managed.qosPfcIfPol.id
  description = "Distinguished name of `qosPfcIfPol` object."
}

output "name" {
  value       = aci_rest_managed.qosPfcIfPol.content.name
  description = "Priority flow control policy name."
}
