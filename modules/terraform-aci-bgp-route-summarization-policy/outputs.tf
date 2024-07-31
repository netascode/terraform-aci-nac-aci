output "dn" {
  value       = aci_rest_managed.bgpRtSummPol.id
  description = "Distinguished name of `bgpRtSummPol` object."
}

output "name" {
  value       = aci_rest_managed.bgpRtSummPol.content.name
  description = "BGP Route Summarization Policy name."
}
