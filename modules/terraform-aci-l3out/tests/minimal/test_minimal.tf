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

  tenant        = "TF"
  name          = "L3OUT1"
  routed_domain = "RD1"
  vrf           = "VRF1"
  multipod      = false
}

data "aci_rest_managed" "l3extOut" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extOut" {
  component = "l3extOut"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extOut.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "l3extRsL3DomAtt" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsl3DomAtt"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsL3DomAtt" {
  component = "l3extRsL3DomAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.l3extRsL3DomAtt.content.tDn
    want        = "uni/l3dom-RD1"
  }
}

data "aci_rest_managed" "l3extRsEctx" {
  dn = "${data.aci_rest_managed.l3extOut.id}/rsectx"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsEctx" {
  component = "l3extRsEctx"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.l3extRsEctx.content.tnFvCtxName
    want        = "VRF1"
  }
}
