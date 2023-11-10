output "dn" {
  value       = aci_rest_managed.rtctrlAttrP.id
  description = "Distinguished name of `rtctrlAttrP` object."
}

output "name" {
  value       = aci_rest_managed.rtctrlAttrP.content.name
  description = "Set rule name."
}
