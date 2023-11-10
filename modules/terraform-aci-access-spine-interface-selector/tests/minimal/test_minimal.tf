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

resource "aci_rest_managed" "infraSpAccPortP" {
  dn         = "uni/infra/spaccportprof-SPINE1001"
  class_name = "infraSpAccPortP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest_managed.infraSpAccPortP.content.name
  name              = "1-1"
}

data "aci_rest_managed" "infraSHPortS" {
  dn = "uni/infra/spaccportprof-SPINE1001/shports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraSHPortS" {
  component = "infraSHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSHPortS.content.name
    want        = module.main.name
  }
}
