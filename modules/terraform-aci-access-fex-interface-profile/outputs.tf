output "dn" {
  value       = aci_rest_managed.infraFexP.id
  description = "Distinguished name of `infraFexP` object."
}

output "name" {
  value       = aci_rest_managed.infraFexP.content.name
  description = "FEX interface profile name."
}
