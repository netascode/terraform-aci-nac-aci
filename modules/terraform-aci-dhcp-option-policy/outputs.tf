output "dn" {
  value       = aci_rest_managed.dhcpOptionPol.id
  description = "Distinguished name of `dhcpOptionPol` object."
}

output "name" {
  value       = aci_rest_managed.dhcpOptionPol.content.name
  description = "DHCP option policy name."
}
