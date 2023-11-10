output "dn" {
  value       = aci_rest_managed.firmwareFwGrp.id
  description = "Distinguished name of `firmwareFwGrp` object."
}

output "name" {
  value       = aci_rest_managed.firmwareFwGrp.content.name
  description = "Firmware group name."
}
