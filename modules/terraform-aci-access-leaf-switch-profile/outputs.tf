output "dn" {
  value       = aci_rest_managed.infraNodeP.id
  description = "Distinguished name of `infraNodeP` object."
}

output "name" {
  value       = aci_rest_managed.infraNodeP.content.name
  description = "Leaf switch profile name."
}
