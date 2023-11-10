output "dn" {
  value       = aci_rest_managed.infraHPortS.id
  description = "Distinguished name of `infraHPortS` object."
}

output "name" {
  value       = aci_rest_managed.infraHPortS.content.name
  description = "FEX interface selector name."
}
