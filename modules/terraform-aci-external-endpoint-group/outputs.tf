output "dn" {
  value       = aci_rest_managed.l3extInstP.id
  description = "Distinguished name of `l3extInstP` object."
}

output "name" {
  value       = aci_rest_managed.l3extInstP.content.name
  description = "External endpoint group name."
}

output "tag_annotation_ids" {
  value       = { for k, v in aci_rest_managed.tagAnnotation : k => v.id }
  description = "Map of tagAnnotation `key` to managed object id (DN) for each child under `l3extInstP`."
}
