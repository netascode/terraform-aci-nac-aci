output "dn" {
  value       = aci_rest_managed.bfdMhNodePol.id
  description = "Distinguished name of `bfdMhNodePol` object."
}

output "name" {
  value       = aci_rest_managed.bfdMhNodePol.content.name
  description = "BFD Multihop node policy name."
}
