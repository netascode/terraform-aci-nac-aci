output "dn" {
  value       = aci_rest_managed.spanVSrcGrp.id
  description = "Distinguished name of `spanVSrcGrp` object."
}

output "name" {
  value       = aci_rest_managed.spanVSrcGrp.content.name
  description = "VSPAN session name."
}
