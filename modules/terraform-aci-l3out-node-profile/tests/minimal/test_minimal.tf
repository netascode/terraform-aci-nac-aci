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

resource "aci_rest_managed" "l3extOut" {
  dn         = "${aci_rest_managed.fvTenant.dn}/out-L3OUT1"
  class_name = "l3extOut"
}

module "main" {
  source = "../.."

  tenant      = "TF"
  l3out       = "L3OUT1"
  name        = "NP1"
  multipod    = false
  remote_leaf = false

  depends_on = [aci_rest_managed.l3extOut]
}

data "aci_rest_managed" "l3extLNodeP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extLNodeP" {
  component = "l3extLNodeP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extLNodeP.content.name
    want        = module.main.name
  }
}
