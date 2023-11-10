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

  name        = "CDP1"
  admin_state = true
}

data "aci_rest_managed" "cdpIfPol" {
  dn = "uni/infra/cdpIfP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "cdpIfPol" {
  component = "cdpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.cdpIfPol.content.name
    want        = module.main.name
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.cdpIfPol.content.adminSt
    want        = "enabled"
  }
}
