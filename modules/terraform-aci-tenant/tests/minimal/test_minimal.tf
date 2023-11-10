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

  name = "ABC"
}

data "aci_rest_managed" "fvTenant" {
  dn = "uni/tn-ABC"

  depends_on = [module.main]
}

resource "test_assertions" "fvTenant" {
  component = "fvTenant"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvTenant.content.name
    want        = "ABC"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.fvTenant.content.nameAlias
    want        = ""
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvTenant.content.descr
    want        = ""
  }
}
