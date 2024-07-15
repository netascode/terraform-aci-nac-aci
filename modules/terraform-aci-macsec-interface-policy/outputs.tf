output "id" {
  value = aci_rest_managed.macsecIfPol.id
  description = "MACsec Interface Policy id"
}

output "name" {
  value = aci_rest_managed.macsecIfPol.content.name
  description = "MACsec Interface Policy name"
}