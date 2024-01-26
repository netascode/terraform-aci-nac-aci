output "dn" {
  value       = "${var.physical_media_type == "auto" ? aci_rest_managed.fabricHIfPol[0].id : ""}"
  description = "Distinguished name of `fabricHIfPol` object."
}

output "dn2" {
  value       = "${var.physical_media_type == "sfp-10g-tx" ? aci_rest_managed.fabricHIfPol_sfp-10g-tx[0].id : ""}"
  description = "Distinguished name of `fabricHIfPol` object."
}

output "name" {
  value       = aci_rest_managed.fabricHIfPol[0].content.name
  description = "Link level interface policy name."
}
