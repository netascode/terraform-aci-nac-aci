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

  coop_group_policy = "strict"
}

data "aci_rest_managed" "coopPol" {
  dn = "uni/fabric/pol-default"

  depends_on = [module.main]
}

resource "test_assertions" "coopPol" {
  component = "coopPol"

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.coopPol.content.type
    want        = "strict"
  }
}
