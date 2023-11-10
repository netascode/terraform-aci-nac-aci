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

  name = "FAST"
}

data "aci_rest_managed" "lacpIfPol" {
  dn = "uni/infra/lacpifp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "lacpIfPol" {
  component = "lacpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.lacpIfPol.content.name
    want        = module.main.name
  }
}
