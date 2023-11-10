output "dn" {
  value       = aci_rest_managed.geoSite.id
  description = "Distinguished name of `geoSite` object."
}

output "name" {
  value       = aci_rest_managed.geoSite.content.name
  description = "Site name."
}
