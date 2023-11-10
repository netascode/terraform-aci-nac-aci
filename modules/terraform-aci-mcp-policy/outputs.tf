output "dn" {
  value       = aci_rest_managed.mcpIfPol.id
  description = "Distinguished name of `mcpIfPol` object."
}

output "name" {
  value       = aci_rest_managed.mcpIfPol.content.name
  description = "MCP policy name."
}
