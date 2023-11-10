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

data "aci_rest_managed" "bgpPeerPfxPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bgpPfxP-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "bgpPeerPfxPol" {
  component = "bgpPeerPfxPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.descr
    want        = ""
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.action
    want        = "reject"
  }

  equal "maxPfx" {
    description = "maxPfx"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.maxPfx
    want        = "20000"
  }

  equal "restartTime" {
    description = "restartTime"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.restartTime
    want        = "infinite"
  }

  equal "thresh" {
    description = "thresh"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.thresh
    want        = "75"
  }
}
