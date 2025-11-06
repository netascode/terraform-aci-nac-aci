output "dn" {
  value       = aci_rest_managed.netflowRecordPol.id
  description = "Distinguished name of `netflowRecordPol` object."
}

output "name" {
  value       = aci_rest_managed.netflowRecordPol.content.name
  description = "Netflow Record name."
}
