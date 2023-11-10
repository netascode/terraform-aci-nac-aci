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

  tenant          = aci_rest_managed.fvTenant.content.name
  name            = "TEST_FULL"
  description     = "My Description"
  preferred_group = true
}

data "aci_rest_managed" "vnsSvcEPgPol" {
  dn = "uni/tn-TF/svcCont/svcEPgPol-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "vnsSvcEPgPol" {
  component = "vnsSvcEPgPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsSvcEPgPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsSvcEPgPol.content.descr
    want        = "My Description"
  }

  equal "prefGrMemb" {
    description = "prefGrMemb"
    got         = data.aci_rest_managed.vnsSvcEPgPol.content.prefGrMemb
    want        = "include"
  }
}
