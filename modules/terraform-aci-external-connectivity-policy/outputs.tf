output "dn" {
  value       = aci_rest_managed.fvFabricExtConnP.id
  description = "Distinguished name of `fvFabricExtConnP` object."
}

output "name" {
  value       = aci_rest_managed.fvFabricExtConnP.content.name
  description = "External connectivity policy name."
}
