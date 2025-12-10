output "dn" {
  value       = aci_rest_managed.hsrpGroupPol.dn
  description = "Distinguished name of the HSRP group policy object."
}

output "name" {
  value       = aci_rest_managed.hsrpGroupPol.content.name
  description = "HSRP group policy name."
}