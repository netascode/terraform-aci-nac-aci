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

  name   = "TAG_MINIMAL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "l3extRouteTagPol" {
  dn = "${aci_rest_managed.fvTenant.id}/rttag-TAG_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRouteTagPol" {
  component = "l3extRouteTagPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extRouteTagPol.content.name
    want        = "TAG_MINIMAL"
  }

  equal "tag" {
    description = "tag"
    got         = data.aci_rest_managed.l3extRouteTagPol.content.tag
    want        = "4294967295"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.l3extRouteTagPol.content.descr
    want        = ""
  }
}
