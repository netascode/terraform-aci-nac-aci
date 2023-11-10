output "dn" {
  value       = aci_rest_managed.igmpSnoopPol.id
  description = "Distinguished name of `igmpSnoopPol` object."
}

output "name" {
  value       = aci_rest_managed.igmpSnoopPol.content.name
  description = "IGMP snooping policy name."
}
