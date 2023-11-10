output "dn" {
  value       = aci_rest_managed.fabricLeafP.id
  description = "Distinguished name of `fabricLeafP` object."
}

output "name" {
  value       = aci_rest_managed.fabricLeafP.content.name
  description = "Leaf switch profile name."
}
