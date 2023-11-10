output "dn" {
  value       = aci_rest_managed.vzFilter.id
  description = "Distinguished name of `vzFilter` object."
}

output "name" {
  value       = aci_rest_managed.vzFilter.content.name
  description = "Filter name."
}
