output "name" {
  value       = aci_rest_managed.macsecKeyChainPol.content.name
  description = "MACsec KeyChain Policy name"
}

output "dn" {
  value       = aci_rest_managed.macsecKeyChainPol.id
  description = "MACsec KeyChain Policy dn"
}
