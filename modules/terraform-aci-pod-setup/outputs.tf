output "dn" {
  value       = aci_rest_managed.fabricSetupP.id
  description = "Distinguished name of `fabricSetupP` object."
}

output "id" {
  value       = aci_rest_managed.fabricSetupP.content.podId
  description = "Pod ID."
}
