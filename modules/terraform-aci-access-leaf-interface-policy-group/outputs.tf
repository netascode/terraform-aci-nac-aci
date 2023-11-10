output "dn" {
  value       = aci_rest_managed.infraAccGrp.id
  description = "Distinguished name of `infraAccGrp` object."
}

output "name" {
  value       = aci_rest_managed.infraAccGrp.content.name
  description = "Leaf interface policy group name."
}
