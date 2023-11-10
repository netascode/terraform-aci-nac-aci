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

  name = "EXT-POL1"
}

data "aci_rest_managed" "fvFabricExtConnP" {
  dn = "uni/tn-infra/fabricExtConnP-1"

  depends_on = [module.main]
}

resource "test_assertions" "fvFabricExtConnP" {
  component = "fvFabricExtConnP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvFabricExtConnP.content.name
    want        = module.main.name
  }
}
