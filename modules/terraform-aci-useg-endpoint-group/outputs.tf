output "dn" {
  value       = aci_rest_managed.fvAEPg.id
  description = "Distinguished name of uSeg `fvAEPg` object."
}

output "name" {
  value       = aci_rest_managed.fvAEPg.content.name
  description = "uSeg Endpoint group name."
}
