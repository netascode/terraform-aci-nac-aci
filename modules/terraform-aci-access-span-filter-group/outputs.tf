output "dn" {
  value       = aci_rest_managed.spanFilterGrp.id
  description = "Distinguished name of `spanFilterGrp` object."
}

output "name" {
  value       = aci_rest_managed.spanFilterGrp.content.name
  description = "SPAN Filter Group name."
}
