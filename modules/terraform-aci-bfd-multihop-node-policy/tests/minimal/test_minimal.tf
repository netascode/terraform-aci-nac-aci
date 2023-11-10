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
  name   = "BFD-MHOP"
}

data "aci_rest_managed" "bfdMhNodePol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bfdMhNodePol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bfdMhNodePol" {
  component = "bfdMhNodePol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bfdMhNodePol.content.name
    want        = "BFD-MHOP"
  }
}
