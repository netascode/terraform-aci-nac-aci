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

  tenant = aci_rest_managed.fvTenant.content.name
  name   = "DEV1"
}

data "aci_rest_managed" "vnsLDevVip" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/lDevVip-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLDevVip" {
  component = "vnsLDevVip"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsLDevVip.content.name
    want        = module.main.name
  }
}
