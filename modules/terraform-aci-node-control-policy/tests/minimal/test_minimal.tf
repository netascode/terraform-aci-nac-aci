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

  name = "NC1"
}

data "aci_rest_managed" "fabricNodeControl" {
  dn = "uni/fabric/nodecontrol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodeControl" {
  component = "fabricNodeControl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricNodeControl.content.name
    want        = module.main.name
  }
}
