output "dn" {
  value       = aci_rest_managed.qosVxlanCustomPol.id
  description = "Distinguished name of `qosVxlanCustomPol` object."
}

output "name" {
  value       = aci_rest_managed.qosVxlanCustomPol.content.name
  description = "Vxlan Custom QoS Policy name."
}
