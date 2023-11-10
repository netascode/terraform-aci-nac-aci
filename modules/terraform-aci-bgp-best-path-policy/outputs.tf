output "dn" {
  value       = aci_rest_managed.bgpBestPathCtrlPol.id
  description = "Distinguished name of `bgpBestPathCtrlPol` object."
}

output "name" {
  value       = aci_rest_managed.bgpBestPathCtrlPol.content.name
  description = "BGP best path policy name."
}
