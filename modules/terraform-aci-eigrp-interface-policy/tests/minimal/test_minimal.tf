terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.0"
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
  name   = "EIGRP1"
}

data "aci_rest_managed" "eigrpIfPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "eigrpIfPol" {
  component = "eigrpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.eigrpIfPol.content.name
    want        = module.main.name
  }
}
