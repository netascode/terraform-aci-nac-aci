output "dn" {
  value       = aci_rest_managed.vmmDomP.id
  description = "Distinguished name of `vmmDomP` object."
}

output "name" {
  value       = aci_rest_managed.vmmDomP.content.name
  description = "VMware VMM domain name."
}
