output "dn" {
  value       = aci_rest_managed.bfdInstPol.id
  description = "Distinguished name of `bfdInstPol` object."
}

output "name" {
  value       = aci_rest_managed.bfdInstPol.content.name
  description = "BFD Policy name."
}
