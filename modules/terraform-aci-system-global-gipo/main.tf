resource "aci_rest_managed" "fmcastSystemGIPoPol" {
  dn         = "uni/infra/systemgipopol"
  class_name = "fmcastSystemGIPoPol"
  content = {
    useConfiguredSystemGIPo = var.use_infra_gipo == true ? "enabled" : "disabled"
  }
}
