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

  name = "MTU_POL"
}

data "aci_rest_managed" "l2InstPol" {
  dn = "uni/fabric/l2pol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "l2InstPol" {
  component = "l2InstPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l2InstPol.content.name
    want        = "MTU_POL"
  }
}