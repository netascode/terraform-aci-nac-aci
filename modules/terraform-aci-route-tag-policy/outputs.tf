output "dn" {
  value       = aci_rest_managed.l3extRouteTagPol.id
  description = "Distinguished name of `l3extRouteTagPol` object."
}

output "name" {
  value       = aci_rest_managed.l3extRouteTagPol.content.name
  description = "Route Tag Policy name."
}
