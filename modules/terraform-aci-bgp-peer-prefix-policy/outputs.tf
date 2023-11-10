output "dn" {
  value       = aci_rest_managed.bgpPeerPfxPol.id
  description = "Distinguished name of `bgpPeerPfxPol` object."
}

output "name" {
  value       = aci_rest_managed.bgpPeerPfxPol.content.name
  description = "BGP Peer Prefix Policy name."
}
