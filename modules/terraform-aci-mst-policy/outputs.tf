output "dn" {
  value       = aci_rest_managed.stpMstRegionPol.id
  description = "Distinguished name of `stpMstRegionPol` object."
}

output "name" {
  value       = aci_rest_managed.stpMstRegionPol.content.name
  description = "MST policy name."
}
