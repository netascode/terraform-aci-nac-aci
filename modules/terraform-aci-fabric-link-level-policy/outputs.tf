output "dn" {
  value       = aci_rest_managed.fabricFIfPol.id
  description = "Distinguished name of `fabricFIfPol` object."
}

output "name" {
  value       = aci_rest_managed.fabricFIfPol.content.name
  description = "Fabric link level policy name."
}
