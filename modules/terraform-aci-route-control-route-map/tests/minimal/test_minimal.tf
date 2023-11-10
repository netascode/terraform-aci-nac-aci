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
  name   = "RCRM_MINIMAL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "rtctrlProfile" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/prof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile" {
  component = "rtctrlProfile"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.rtctrlProfile.content.name
    want        = "RCRM_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.rtctrlProfile.content.descr
    want        = ""
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.rtctrlProfile.content.type
    want        = "combinable"
  }
}
