output "dn" {
  value       = aci_rest_managed.fvTrackMember.id
  description = "Distinguished name of `fvTrackMember` object."
}

output "name" {
  value       = aci_rest_managed.fvTrackMember.content.name
  description = "Track Member name."
}
