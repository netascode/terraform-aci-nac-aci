output "dn" {
  value       = aci_rest_managed.infraAccPortP.id
  description = "Distinguished name of `infraAccPortP` object."
}

output "name" {
  value       = aci_rest_managed.infraAccPortP.content.name
  description = "Leaf interface profile name."
}
