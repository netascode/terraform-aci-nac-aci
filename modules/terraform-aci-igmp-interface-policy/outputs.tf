output "dn" {
  value       = aci_rest_managed.igmpIfPol.id
  description = "Distinguished name of `igmpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.igmpIfPol.content.name
  description = "IGMP interface policy name."
}
