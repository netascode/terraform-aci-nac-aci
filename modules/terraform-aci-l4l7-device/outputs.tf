output "dn" {
  value       = aci_rest_managed.vnsLDevVip.id
  description = "Distinguished name of `vnsLDevVip` object."
}

output "name" {
  value       = aci_rest_managed.vnsLDevVip.content.name
  description = "L4L7 device name."
}
