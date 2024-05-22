output "dn" {
  value       = aci_rest_managed.ptpProfile.id
  description = "Distinguished name of `ptpProfile` object."
}

output "name" {
  value       = aci_rest_managed.ptpProfile.content.name
  description = "PTP Profile Name."
}
