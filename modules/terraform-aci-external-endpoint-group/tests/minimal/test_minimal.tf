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
  dn         = "uni/tn-${aci_rest_managed.fvTenant.content.name}/out-L3OUT1"
  class_name = "l3extOut"
}

module "main" {
  source = "../.."

  tenant = aci_rest_managed.fvTenant.content.name
  l3out  = aci_rest_managed.l3extOut.content.name
  name   = "EXTEPG1"
}

data "aci_rest_managed" "l3extInstP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extInstP" {
  component = "l3extInstP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l3extInstP.content.name
    want        = module.main.name
  }
}
