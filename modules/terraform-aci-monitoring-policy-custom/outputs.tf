output "dn" {
  value       = aci_rest_managed.monFabricPol.id
  description = "Distinguished name of Fabric `monFabricPol` object."
}

output "name" {
  value       = aci_rest_managed.monFabricPol.content.name
  description = "Custom Fabric Monitoring Policy name."
}