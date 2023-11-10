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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  name   = "TEST_MINIMAL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "pimRouteMapPol" {
  dn = "${aci_rest_managed.fvTenant.id}/rtmap-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "pimRouteMapPol" {
  component = "pimRouteMapPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pimRouteMapPol.content.name
    want        = "TEST_MINIMAL"
  }
}
