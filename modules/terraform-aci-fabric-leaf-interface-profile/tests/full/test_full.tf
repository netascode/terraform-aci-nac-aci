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

  name = "LEAF101"
}

data "aci_rest_managed" "fabricLePortP" {
  dn = "uni/fabric/leportp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLePortP" {
  component = "fabricLePortP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricLePortP.content.name
    want        = module.main.name
  }
}
