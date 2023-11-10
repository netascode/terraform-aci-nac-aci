output "dn" {
  value       = aci_rest_managed.fabricLePortP.id
  description = "Distinguished name of `fabricLePortP` object."
}

output "name" {
  value       = aci_rest_managed.fabricLePortP.content.name
  description = "Leaf interface profile name."
}
