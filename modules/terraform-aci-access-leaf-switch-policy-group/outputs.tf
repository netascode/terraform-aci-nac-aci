output "dn" {
  value       = aci_rest_managed.infraAccNodePGrp.id
  description = "Distinguished name of `infraAccNodePGrp` object."
}

output "name" {
  value       = aci_rest_managed.infraAccNodePGrp.content.name
  description = "Leaf switch policy group name."
}
