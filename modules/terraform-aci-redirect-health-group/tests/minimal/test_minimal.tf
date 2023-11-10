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

  name   = "TEST_MINIMAL"
  tenant = aci_rest_managed.fvTenant.content.name

}

data "aci_rest_managed" "vnsRedirectHealthGroup" {
  dn = "${aci_rest_managed.fvTenant.id}/svcCont/redirectHealthGroup-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRedirectHealthGroup" {
  component = "vnsRedirectHealthGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsRedirectHealthGroup.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsRedirectHealthGroup.content.descr
    want        = ""
  }
}
