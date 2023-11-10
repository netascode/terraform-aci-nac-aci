output "dn" {
  value       = aci_rest_managed.trigSchedP.id
  description = "Distinguished name of `trigSchedP` object."
}

output "name" {
  value       = aci_rest_managed.trigSchedP.content.name
  description = "Fabric scheduler name."
}
