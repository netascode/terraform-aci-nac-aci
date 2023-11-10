terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  use_infra_gipo = true
}

data "aci_rest_managed" "fmcastSystemGIPoPol" {
  dn = "uni/infra/systemgipopol"

  depends_on = [module.main]
}

resource "test_assertions" "fmcastSystemGIPoPol" {
  component = "fmcastSystemGIPoPol"

  equal "useConfiguredSystemGIPo" {
    description = "useConfiguredSystemGIPo"
    got         = data.aci_rest_managed.fmcastSystemGIPoPol.content.useConfiguredSystemGIPo
    want        = "enabled"
  }
}
