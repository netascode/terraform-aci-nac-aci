output "dn" {
  value       = aci_rest_managed.fvTrackList.id
  description = "Distinguished name of `fvTrackList` object."
}

output "name" {
  value       = aci_rest_managed.fvTrackList.content.name
  description = "Track List name."
}
