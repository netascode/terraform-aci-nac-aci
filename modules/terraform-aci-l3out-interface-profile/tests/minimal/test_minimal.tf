terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
  content = {
    name = "TF"
  }
}

resource "aci_rest_managed" "l3extOut" {
  dn         = "${aci_rest_managed.fvTenant.dn}/out-L3OUT1"
  class_name = "l3extOut"
  content = {
    name = "L3OUT1"
  }
}

resource "aci_rest_managed" "l3extLNodeP" {
  dn         = "${aci_rest_managed.l3extOut.dn}/lnodep-NP1"
  class_name = "l3extLNodeP"
  content = {
    name = "NP1"
  }
}

module "main" {
  source = "../.."

  tenant       = aci_rest_managed.fvTenant.content.name
  l3out        = aci_rest_managed.l3extOut.content.name
  node_profile = aci_rest_managed.l3extLNodeP.content.name
  name         = "IP1"
}

data "aci_rest_managed" "l3extLIfP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extLIfP" {
  component = "l3extLIfP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extLIfP.content.name
    want        = module.main.name
  }
}
