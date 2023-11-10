output "dn" {
  value       = aci_rest_managed.bgpCtxPol.id
  description = "Distinguished name of `bgpCtxPol` object."
}

output "name" {
  value       = aci_rest_managed.bgpCtxPol.content.name
  description = "BGP timer policy name."
}
