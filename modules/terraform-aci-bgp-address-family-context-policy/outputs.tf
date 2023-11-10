output "dn" {
  value       = aci_rest_managed.bgpCtxAfPol.id
  description = "Distinguished name of `bgpCtxAfPol` object."
}

output "name" {
  value       = aci_rest_managed.bgpCtxAfPol.content.name
  description = "BGP Address Family Context Policy name."
}
