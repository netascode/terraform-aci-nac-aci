output "dn" {
  value       = aci_rest_managed.vxlanBgwSet.id
  description = "Distinguished name of vxlanBgwSet object."
}

output "name" {
  value       = aci_rest_managed.vxlanBgwSet.content.name
  description = "Name of vxlanBgwSet object."
}