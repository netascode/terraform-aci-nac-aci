output "dn" {
  value       = aci_rest_managed.infraSpAccPortP.id
  description = "Distinguished name of `infraSpAccPortP` object."
}

output "name" {
  value       = aci_rest_managed.infraSpAccPortP.content.name
  description = "Spine interface profile name."
}
