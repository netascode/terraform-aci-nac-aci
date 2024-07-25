output "dn" {
  value       = aci_rest_managed.mplsSrgbLabelPol.id
  description = "Distinguished name of `mplsSrgbLabelPol` object."
}

output "name" {
  value       = aci_rest_managed.mplsSrgbLabelPol.content.name
  description = "SR MPLS global configuration name."
}
