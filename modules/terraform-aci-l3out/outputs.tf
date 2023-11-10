output "dn" {
  value       = aci_rest_managed.l3extOut.id
  description = "Distinguished name of `l3extOut` object."
}

output "name" {
  value       = aci_rest_managed.l3extOut.content.name
  description = "L3out name."
}
