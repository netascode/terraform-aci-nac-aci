output "dn" {
  value       = aci_rest_managed.dhcpRelayP.id
  description = "Distinguished name of `dhcpRelayP` object."
}

output "name" {
  value       = aci_rest_managed.dhcpRelayP.content.name
  description = "DHCP relay policy name."
}
