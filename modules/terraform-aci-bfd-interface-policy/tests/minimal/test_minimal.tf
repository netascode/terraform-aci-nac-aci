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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant = aci_rest_managed.fvTenant.content.name
  name   = "BFD1"
}

data "aci_rest_managed" "bfdIfPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bfdIfPol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bfdIfPol" {
  component = "bfdIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bfdIfPol.content.name
    want        = module.main.name
  }
}
