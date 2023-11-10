output "dn" {
  value       = aci_rest_managed.vnsAbsGraph.id
  description = "Distinguished name of `vnsAbsGraph` object."
}

output "name" {
  value       = aci_rest_managed.vnsAbsGraph.content.name
  description = "Service graph template name."
}
