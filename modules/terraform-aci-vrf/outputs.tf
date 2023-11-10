output "dn" {
  value       = aci_rest_managed.fvCtx.id
  description = "Distinguished name of `fvCtx` object."
}

output "name" {
  value       = aci_rest_managed.fvCtx.content.name
  description = "VRF name."
}
