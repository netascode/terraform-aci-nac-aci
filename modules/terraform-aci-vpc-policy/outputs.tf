output "dn" {
  value       = aci_rest_managed.vpcInstPol.id
  description = "Distinguished name of `vpcInstPol` object."
}

output "name" {
  value       = aci_rest_managed.vpcInstPol.content.name
  description = "VPC policy name."
}
