output "dn" {
  value       = aci_rest_managed.fabricPodP.id
  description = "Distinguished name of `fabricPodP` object."
}

output "name" {
  value       = aci_rest_managed.fabricPodP.content.name
  description = "Fabric pod profile name."
}
