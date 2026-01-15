output "dn" {
  value       = aci_rest_managed.hsrpIfPol.dn
  description = "Distinguished name of the HSRP interface policy object."
}

output "name" {
  value       = aci_rest_managed.hsrpIfPol.content.name
  description = "HSRP interface policy name."
}