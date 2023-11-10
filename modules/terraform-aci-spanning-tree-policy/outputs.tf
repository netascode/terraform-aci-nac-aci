output "dn" {
  value       = aci_rest_managed.stpIfPol.id
  description = "Distinguished name of `stpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.stpIfPol.content.name
  description = "Spanning tree policy name."
}
