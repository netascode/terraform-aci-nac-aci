output "dn" {
  value       = aci_rest_managed.l3extLIfP.id
  description = "Distinguished name of `l3extLIfP` object."
}

output "name" {
  value       = aci_rest_managed.l3extLIfP.content.name
  description = "Interface profile name."
}
