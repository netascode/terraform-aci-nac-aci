output "dn" {
  value       = aci_rest_managed.ndPfxPol.id
  description = "Distinguished name of `ndPfxPol` object."
}

output "name" {
  value       = aci_rest_managed.ndPfxPol.content.name
  description = "ND RA prefix policy name."
}
