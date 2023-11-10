output "dn" {
  value       = aci_rest_managed.fhsTrustCtrlPol.id
  description = "Distinguished name of `fhsTrustCtrlPol` object."
}

output "name" {
  value       = aci_rest_managed.fhsTrustCtrlPol.content.name
  description = "Trust control policy name."
}
