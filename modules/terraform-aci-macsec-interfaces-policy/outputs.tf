output "dn" {
  value       = aci_rest_managed.macsecIfPol.content.dn
  description = "MACsec Interface Policy dn"
}

output "name" {
  value       = aci_rest_managed.macsecIfPol.content.name
  description = "MACsec Interface Policy name"
}