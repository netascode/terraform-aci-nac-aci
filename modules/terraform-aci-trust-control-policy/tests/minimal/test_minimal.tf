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
  name   = "TEST_MINIMAL"
}

data "aci_rest_managed" "fhsTrustCtrlPol" {
  dn = "uni/tn-TF/trustctrlpol-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "fhsTrustCtrlPol" {
  component = "fhsTrustCtrlPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.name
    want        = "TEST_MINIMAL"
  }
}
