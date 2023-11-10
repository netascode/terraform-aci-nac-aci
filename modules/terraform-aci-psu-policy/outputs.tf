output "dn" {
  value       = aci_rest_managed.psuInstPol.id
  description = "Distinguished name of `psuInstPol` object."
}

output "name" {
  value       = aci_rest_managed.psuInstPol.content.name
  description = "PSU policy name."
}
