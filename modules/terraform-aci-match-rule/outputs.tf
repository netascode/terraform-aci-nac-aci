output "dn" {
  value       = aci_rest_managed.rtctrlSubjP.id
  description = "Distinguished name of `rtctrlSubjP` object."
}

output "name" {
  value       = aci_rest_managed.rtctrlSubjP.content.name
  description = "Match rule name."
}
