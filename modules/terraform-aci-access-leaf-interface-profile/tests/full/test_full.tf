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

  name = "INT-PROF1"
}

data "aci_rest_managed" "infraAccPortP" {
  dn = "uni/infra/accportprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAccPortP" {
  component = "infraAccPortP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAccPortP.content.name
    want        = module.main.name
  }
}
