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
  name   = "MIN_POL"
  tenant = aci_rest_managed.fvTenant.content.name
}

data "aci_rest_managed" "pimIfPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/pimifpol-MIN_POL"

  depends_on = [module.main]
}

resource "test_assertions" "pimIfPol" {
  component = "pimIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pimIfPol.content.name
    want        = "MIN_POL"
  }

  equal "authKey" {
    description = "authKey"
    got         = data.aci_rest_managed.pimIfPol.content.authKey
    want        = ""
  }

  equal "authT" {
    description = "authT"
    got         = data.aci_rest_managed.pimIfPol.content.authT
    want        = "none"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimIfPol.content.ctrl
    want        = ""
  }

  equal "drDelay" {
    description = "drDelay"
    got         = data.aci_rest_managed.pimIfPol.content.drDelay
    want        = "3"
  }

  equal "drPrio" {
    description = "drPrio"
    got         = data.aci_rest_managed.pimIfPol.content.drPrio
    want        = "1"
  }

  equal "helloItvl" {
    description = "helloItvl"
    got         = data.aci_rest_managed.pimIfPol.content.helloItvl
    want        = "30000"
  }

  equal "jpInterval" {
    description = "jpInterval"
    got         = data.aci_rest_managed.pimIfPol.content.jpInterval
    want        = "60"
  }
}
