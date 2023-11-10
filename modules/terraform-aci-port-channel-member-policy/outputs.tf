output "dn" {
  value       = aci_rest_managed.lacpIfPol.id
  description = "Distinguished name of `lacpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.lacpIfPol.content.name
  description = "Port channel member policy name."
}
