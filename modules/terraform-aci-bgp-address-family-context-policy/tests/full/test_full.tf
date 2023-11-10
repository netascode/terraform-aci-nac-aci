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

  name                   = "TEST_FULL"
  tenant                 = aci_rest_managed.fvTenant.content.name
  description            = "My BGP Policy"
  enable_host_route_leak = true
  ebgp_distance          = 21
  ibgp_distance          = 201
  local_distance         = 221
  local_max_ecmp         = 4
  ebgp_max_ecmp          = 8
  ibgp_max_ecmp          = 8
}

data "aci_rest_managed" "bgpCtxAfPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bgpCtxAfP-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "bgpCtxAfPol" {
  component = "bgpCtxAfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.descr
    want        = "My BGP Policy"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.ctrl
    want        = "host-rt-leak"
  }

  equal "eDist" {
    description = "eDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.eDist
    want        = "21"
  }

  equal "iDist" {
    description = "iDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.iDist
    want        = "201"
  }

  equal "localDist" {
    description = "localDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.localDist
    want        = "221"
  }

  equal "maxLocalEcmp" {
    description = "maxLocalEcmp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxLocalEcmp
    want        = "4"
  }

  equal "maxEcmp" {
    description = "maxEcmp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxEcmp
    want        = "8"
  }

  equal "maxEcmpIbgp" {
    description = "maxEcmpIbgp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxEcmpIbgp
    want        = "8"
  }
}
