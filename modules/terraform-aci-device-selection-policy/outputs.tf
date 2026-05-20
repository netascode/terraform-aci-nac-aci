output "dn" {
  value       = length(var.devices) > 0 ? values(aci_rest_managed.vnsLDevCtx_multi)[*].id : (length(aci_rest_managed.vnsLDevCtx) > 0 ? [aci_rest_managed.vnsLDevCtx[0].id] : [])
  description = "Distinguished name of `vnsLDevCtx` object(s). Returns a list of DNs."
}
