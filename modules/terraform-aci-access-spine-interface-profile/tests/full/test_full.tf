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

  name = "PROF1"
}

data "aci_rest_managed" "infraSpAccPortP" {
  dn = "uni/infra/spaccportprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpAccPortP" {
  component = "infraSpAccPortP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpAccPortP.content.name
    want        = module.main.name
  }
}
