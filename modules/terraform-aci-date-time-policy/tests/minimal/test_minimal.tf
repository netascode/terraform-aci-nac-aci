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

  name = "DATE1"
}

data "aci_rest_managed" "datetimePol" {
  dn = "uni/fabric/time-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "datetimePol" {
  component = "datetimePol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.datetimePol.content.name
    want        = module.main.name
  }
}
