locals {
  yaml_strings_directories = flatten([
    for dir in var.yaml_directories : [
      for file in fileset(".", "${dir}/*.{yml,yaml}") : file(file)
    ]
  ])
  yaml_strings_files = [
    for file in var.yaml_files : file(file)
  ]
  model_strings   = length(keys(var.model)) != 0 ? [yamlencode(var.model)] : []
  model_string    = provider::utils::yaml_merge(concat(local.yaml_strings_directories, local.yaml_strings_files, local.model_strings))
  model           = yamldecode(local.model_string)
  user_defaults   = { "defaults" : try(local.model["defaults"], {}) }
  defaults_string = provider::utils::yaml_merge([file("${path.module}/defaults/defaults.yaml"), yamlencode(local.user_defaults)])
  defaults        = yamldecode(local.defaults_string)["defaults"]
  user_modules    = { "modules" : try(local.model["modules"], {}) }
  modules_string  = provider::utils::yaml_merge([file("${path.module}/defaults/modules.yaml"), yamlencode(local.user_modules)])
  modules         = yamldecode(local.modules_string)["modules"]
}

resource "terraform_data" "validation" {
  lifecycle {
    precondition {
      condition     = length(var.yaml_directories) != 0 || length(var.yaml_files) != 0 || length(keys(var.model)) != 0
      error_message = "Either `yaml_directories`,`yaml_files` or a non-empty `model` value must be provided."
    }
  }
}

resource "local_sensitive_file" "defaults" {
  count    = var.write_default_values_file != "" ? 1 : 0
  content  = local.defaults_string
  filename = var.write_default_values_file
}
