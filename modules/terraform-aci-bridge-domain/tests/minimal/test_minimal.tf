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
  name   = "BD1"
  vrf    = "VRF1"
}

data "aci_rest_managed" "fvBD" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/BD-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvBD" {
  component = "fvBD"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvBD.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fvRsCtx" {
  dn = "${data.aci_rest_managed.fvBD.id}/rsctx"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsCtx" {
  component = "fvRsCtx"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.fvRsCtx.content.tnFvCtxName
    want        = "VRF1"
  }
}
