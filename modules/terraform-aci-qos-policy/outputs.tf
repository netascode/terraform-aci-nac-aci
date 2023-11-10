output "dn" {
  value       = aci_rest_managed.qosCustomPol.id
  description = "Distinguished name of `qosCustomPol` object."
}

output "name" {
  value       = aci_rest_managed.qosCustomPol.content.name
  description = "QoS Custom Policy name."
}
