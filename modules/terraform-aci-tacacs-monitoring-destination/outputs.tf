output "dn" {
  value       = aci_rest_managed.tacacsGroup.id
  description = "Distinguished name of `tacacsGroup` object."
}

output "name" {
  value       = aci_rest_managed.tacacsGroup.content.name
  description = "TACACS monitoring destination group name."
}
