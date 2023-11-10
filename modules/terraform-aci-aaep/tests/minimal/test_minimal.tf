terraform {
  required_version = ">= 1.3.0"

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

  name = "AAEP1"
}

data "aci_rest_managed" "infraAttEntityP" {
  dn = "uni/infra/attentp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAttEntityP" {
  component = "infraAttEntityP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAttEntityP.content.name
    want        = module.main.name
  }
}
