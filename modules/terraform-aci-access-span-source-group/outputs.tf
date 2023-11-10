output "dn" {
  value       = aci_rest_managed.spanSrcGrp.id
  description = "Distinguished name of `spanSrcGrp` object."
}

output "name" {
  value       = aci_rest_managed.spanSrcGrp.content.name
  description = "SPAN Source Group name."
}
