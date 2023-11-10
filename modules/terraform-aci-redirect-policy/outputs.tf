output "dn" {
  value       = aci_rest_managed.vnsSvcRedirectPol.id
  description = "Distinguished name of `vnsSvcRedirectPol` object."
}

output "name" {
  value       = aci_rest_managed.vnsSvcRedirectPol.content.name
  description = "Redirect policy name."
}
