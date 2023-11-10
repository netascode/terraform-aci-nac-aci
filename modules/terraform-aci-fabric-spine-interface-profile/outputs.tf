output "dn" {
  value       = aci_rest_managed.fabricSpPortP.id
  description = "Distinguished name of `fabricSpPortP` object."
}

output "name" {
  value       = aci_rest_managed.fabricSpPortP.content.name
  description = "Spine interface profile name."
}
