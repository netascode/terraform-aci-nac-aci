output "dn" {
  value       = aci_rest_managed.stormctrlIfPol.id
  description = "Distinguished name of `stormctrlIfPol` object."
}

output "name" {
  value       = aci_rest_managed.stormctrlIfPol.content.name
  description = "Storm control policy name."
}
