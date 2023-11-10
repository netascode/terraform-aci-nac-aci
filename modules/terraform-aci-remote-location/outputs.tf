output "dn" {
  value       = aci_rest_managed.fileRemotePath.id
  description = "Distinguished name of `fileRemotePath` object."
}

output "name" {
  value       = aci_rest_managed.fileRemotePath.content.name
  description = "Remote location name."
}
