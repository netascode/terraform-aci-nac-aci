output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "defaults_yaml" {
  description = "All default values in YAML string (same content as `write_default_values_file`)."
  value       = local.defaults_string
  sensitive   = true
}

output "model" {
  description = "Full model."
  value       = local.model
}
