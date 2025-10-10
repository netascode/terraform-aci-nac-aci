output "dn" {
  value       = aci_rest_managed.netflowMonitorPol.id
  description = "Distinguished name of `netflowMonitorPol` object."
}

output "name" {
  value       = aci_rest_managed.netflowMonitorPol.content.name
  description = "Netflow Monitor name."
}
