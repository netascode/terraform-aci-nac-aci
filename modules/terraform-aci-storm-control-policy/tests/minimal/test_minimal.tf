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

  name = "SC1"
}

data "aci_rest_managed" "stormctrlIfPol" {
  dn = "uni/infra/stormctrlifp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "stormctrlIfPol" {
  component = "stormctrlIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.stormctrlIfPol.content.name
    want        = module.main.name
  }
}
