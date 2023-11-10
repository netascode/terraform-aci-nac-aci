output "dn" {
  value       = aci_rest_managed.pimIfPol.id
  description = "Distinguished name of `pimIfPol` object."
}

output "name" {
  value       = aci_rest_managed.pimIfPol.content.name
  description = "PIM Policy name."
}
