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
  source       = "../.."
  name         = "TEST_FULL"
  tenant       = aci_rest_managed.fvTenant.content.name
  description  = "My BGP Peer Prefix Policy"
  action       = "restart"
  max_prefixes = 10000
  restart_time = 1234
  threshold    = 90
}

data "aci_rest_managed" "bgpPeerPfxPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bgpPfxP-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "bgpPeerPfxPol" {
  component = "bgpPeerPfxPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.descr
    want        = "My BGP Peer Prefix Policy"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.action
    want        = "restart"
  }

  equal "maxPfx" {
    description = "maxPfx"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.maxPfx
    want        = "10000"
  }

  equal "restartTime" {
    description = "restartTime"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.restartTime
    want        = "1234"
  }

  equal "thresh" {
    description = "thresh"
    got         = data.aci_rest_managed.bgpPeerPfxPol.content.thresh
    want        = "90"
  }
}
