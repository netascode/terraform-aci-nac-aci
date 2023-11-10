output "dn" {
  value       = aci_rest_managed.pimRouteMapPol.id
  description = "Distinguished name of `pimRouteMapPol` object."
}

output "name" {
  value       = aci_rest_managed.pimRouteMapPol.content.name
  description = "Multicast route map name."
}
