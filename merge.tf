

locals {
  yaml_strings_directories = flatten([
    for dir in var.yaml_directories : [
      for file in fileset(".", "${dir}/*.{yml,yaml}") : file(file)
    ]
  ])
  yaml_strings_files = [
    for file in var.yaml_files : file(file)
  ]
  model_strings = length(keys(var.model)) != 0 ? [yamlencode(var.model)] : []
  user_defaults = { "defaults" : try(yamldecode(data.utils_yaml_merge.model.output)["defaults"], {}) }
  defaults      = yamldecode(data.utils_yaml_merge.defaults.output)["defaults"]
  user_modules  = { "modules" : try(yamldecode(data.utils_yaml_merge.model.output)["modules"], {}) }
  modules       = yamldecode(data.utils_yaml_merge.modules.output)["modules"]
  model         = yamldecode(data.utils_yaml_merge.model.output)
}

data "utils_yaml_merge" "model" {
  input = concat(local.yaml_strings_directories, local.yaml_strings_files, local.model_strings)

  lifecycle {
    precondition {
      condition     = length(var.yaml_directories) != 0 || length(var.yaml_files) != 0 || length(keys(var.model)) != 0
      error_message = "Either `yaml_directories`,`yaml_files` or a non-empty `model` value must be provided."
    }
  }
}

data "utils_yaml_merge" "defaults" {
  input = [file("${path.module}/defaults/defaults.yaml"), yamlencode(local.user_defaults)]
}

data "utils_yaml_merge" "modules" {
  input = [file("${path.module}/defaults/modules.yaml"), yamlencode(local.user_modules)]
}

resource "local_sensitive_file" "defaults" {
  count    = var.write_default_values_file != "" ? 1 : 0
  content  = data.utils_yaml_merge.defaults.output
  filename = var.write_default_values_file
}
