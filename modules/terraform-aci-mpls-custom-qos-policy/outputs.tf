output "dn" {
  value       = aci_rest_managed.qosMplsCustomPol.id
  description = "Distinguished name of `qosMplsCustomPol` object."
}

output "name" {
  value       = aci_rest_managed.qosMplsCustomPol.content.name
  description = "MPLS Custom QoS Policy name."
}
