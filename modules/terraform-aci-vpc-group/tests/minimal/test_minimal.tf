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

  mode = "consecutive"
}

data "aci_rest_managed" "fabricProtPol" {
  dn = "uni/fabric/protpol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricProtPol" {
  component = "fabricProtPol"

  equal "pairT" {
    description = "pairT"
    got         = data.aci_rest_managed.fabricProtPol.content.pairT
    want        = "consecutive"
  }
}
