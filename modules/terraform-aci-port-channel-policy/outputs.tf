output "dn" {
  value       = aci_rest_managed.lacpLagPol.id
  description = "Distinguished name of `lacpLagPol` object."
}

output "name" {
  value       = aci_rest_managed.lacpLagPol.content.name
  description = "Port channel policy name."
}
