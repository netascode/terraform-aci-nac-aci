output "dn" {
  value       = aci_rest_managed.spanDestGrp.id
  description = "Distinguished name of `spanDestGrp` object."
}

output "name" {
  value       = aci_rest_managed.spanDestGrp.content.name
  description = "Fabric SPAN destination group name."
}
