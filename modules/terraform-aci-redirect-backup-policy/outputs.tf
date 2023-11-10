output "dn" {
  value       = aci_rest_managed.vnsBackupPol.id
  description = "Distinguished name of `vnsBackupPol` object."
}

output "name" {
  value       = aci_rest_managed.vnsBackupPol.content.name
  description = "Redirect backup policy name."
}
