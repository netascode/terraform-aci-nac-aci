output "dn" {
  value       = aci_rest_managed.vzCPIf.id
  description = "Distinguished name of `vzCPIf` object."
}

output "name" {
  value       = aci_rest_managed.vzCPIf.content.name
  description = "Imported contract name."
}
