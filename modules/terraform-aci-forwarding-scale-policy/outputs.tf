output "dn" {
  value       = aci_rest_managed.topoctrlFwdScaleProfilePol.id
  description = "Distinguished name of `topoctrlFwdScaleProfilePol` object."
}

output "name" {
  value       = aci_rest_managed.topoctrlFwdScaleProfilePol.content.name
  description = "Forwarding scale policy name."
}
