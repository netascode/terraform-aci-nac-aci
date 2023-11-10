output "dn" {
  value       = aci_rest_managed.spanVDestGrp.id
  description = "Distinguished name of `spanVDestGrp` object."
}

output "name" {
  value       = aci_rest_managed.spanVDestGrp.content.name
  description = "VSPAN Destination Group name."
}