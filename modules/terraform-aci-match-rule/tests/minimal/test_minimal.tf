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
  name   = "MR1"
}

data "aci_rest_managed" "rtctrlSubjP" {
  dn = "${aci_rest_managed.fvTenant.id}/subj-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlSubjP" {
  component = "rtctrlSubjP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlSubjP.content.name
    want        = module.main.name
  }
}
