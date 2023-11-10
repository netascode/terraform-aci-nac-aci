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

resource "aci_rest_managed" "fvAp" {
  dn         = "${aci_rest_managed.fvTenant.id}/ap-AP1"
  class_name = "fvAp"
}

module "main" {
  source = "../.."

  tenant              = aci_rest_managed.fvTenant.content.name
  application_profile = aci_rest_managed.fvAp.content.name
  name                = "ESG1"
  vrf                 = "VRF1"
}

data "aci_rest_managed" "fvESg" {
  dn = "${aci_rest_managed.fvAp.id}/esg-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvESg" {
  component = "fvESg"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvESg.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fvRsScope" {
  dn = "${data.aci_rest_managed.fvESg.id}/rsscope"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsScope" {
  component = "fvRsScope"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest_managed.fvRsScope.content.tnFvCtxName
    want        = "VRF1"
  }
}
