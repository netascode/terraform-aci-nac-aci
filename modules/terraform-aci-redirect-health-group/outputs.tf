output "dn" {
  value       = aci_rest_managed.vnsRedirectHealthGroup.id
  description = "Distinguished name of `vnsRedirectHealthGroup` object."
}

output "name" {
  value       = aci_rest_managed.vnsRedirectHealthGroup.content.name
  description = "Redirect Health Group name."
}
