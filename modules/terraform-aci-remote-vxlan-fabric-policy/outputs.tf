output "dn" {
  value       = aci_rest_managed.vxlanRemoteFabric.id
  description = "Distinguished name of `vxlanRemoteFabric` object."
}

output "name" {
  value       = aci_rest_managed.vxlanRemoteFabric.content.name
  description = "vxlanRemoteFabric name."
}
