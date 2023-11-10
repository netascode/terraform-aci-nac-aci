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

  name = "LEAF101"
}

data "aci_rest_managed" "fabricLeafP" {
  dn = "uni/fabric/leprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeafP" {
  component = "fabricLeafP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricLeafP.content.name
    want        = module.main.name
  }
}
