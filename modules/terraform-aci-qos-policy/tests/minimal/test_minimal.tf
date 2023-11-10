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
  name   = "MIN_POL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "qosCustomPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/qoscustom-MIN_POL"

  depends_on = [module.main]
}

resource "test_assertions" "qosCustomPol" {
  component = "qosCustomPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.qosCustomPol.content.name
    want        = "MIN_POL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.qosCustomPol.content.descr
    want        = ""
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.qosCustomPol.content.nameAlias
    want        = ""
  }
}
