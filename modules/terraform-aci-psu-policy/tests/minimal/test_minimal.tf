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

  name = "PSU1"
}

data "aci_rest_managed" "psuInstPol" {
  dn = "uni/fabric/psuInstP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "psuInstPol" {
  component = "psuInstPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.psuInstPol.content.name
    want        = module.main.name
  }
}
