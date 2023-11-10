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

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "AP1"
  alias       = "ALIAS"
  description = "DESCR"
}

data "aci_rest_managed" "fvAp" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "fvAp" {
  component = "fvAp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvAp.content.name
    want        = "AP1"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvAp.content.nameAlias
    want        = "ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvAp.content.descr
    want        = "DESCR"
  }
}
