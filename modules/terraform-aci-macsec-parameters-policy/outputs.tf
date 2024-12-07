output "name" {
  value       = aci_rest_managed.macsecParamPol.content.name
  description = "MACsec Parameter Policy name"
}

output "dn" {
  value       = aci_rest_managed.macsecParamPol.id
  description = "MACsec Parameter Policy dn"
}

