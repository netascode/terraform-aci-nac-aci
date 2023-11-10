output "dn" {
  value       = aci_rest_managed.rtctrlProfile.id
  description = "Distinguished name of `rtctrlProfile` object."
}

output "name" {
  value       = aci_rest_managed.rtctrlProfile.content.name
  description = "Route Map name."
}
