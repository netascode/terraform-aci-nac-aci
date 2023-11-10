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

  tenant                  = aci_rest_managed.fvTenant.content.name
  name                    = "BGP1"
  description             = "My Description"
  graceful_restart_helper = false
  hold_interval           = 60
  keepalive_interval      = 30
  maximum_as_limit        = 20
  stale_interval          = "120"
}

data "aci_rest_managed" "bgpCtxPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bgpCtxP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bgpCtxPol" {
  component = "bgpCtxPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpCtxPol.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpCtxPol.content.descr
    want        = "My Description"
  }

  equal "grCtrl" {
    description = "grCtrl"
    got         = data.aci_rest_managed.bgpCtxPol.content.grCtrl
    want        = ""
  }

  equal "holdIntvl" {
    description = "holdIntvl"
    got         = data.aci_rest_managed.bgpCtxPol.content.holdIntvl
    want        = "60"
  }

  equal "kaIntvl" {
    description = "kaIntvl"
    got         = data.aci_rest_managed.bgpCtxPol.content.kaIntvl
    want        = "30"
  }

  equal "maxAsLimit" {
    description = "maxAsLimit"
    got         = data.aci_rest_managed.bgpCtxPol.content.maxAsLimit
    want        = "20"
  }

  equal "staleIntvl" {
    description = "staleIntvl"
    got         = data.aci_rest_managed.bgpCtxPol.content.staleIntvl
    want        = "120"
  }
}
