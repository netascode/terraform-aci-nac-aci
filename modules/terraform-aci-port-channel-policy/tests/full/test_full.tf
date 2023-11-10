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

module "main" {
  source = "../.."

  name                 = "LACP-ACTIVE"
  mode                 = "active"
  min_links            = 2
  max_links            = 10
  suspend_individual   = false
  graceful_convergence = false
  fast_select_standby  = false
  load_defer           = true
  symmetric_hash       = true
  hash_key             = "src-ip"
}

data "aci_rest_managed" "lacpLagPol" {
  dn = "uni/infra/lacplagp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "lacpLagPol" {
  component = "lacpLagPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.lacpLagPol.content.name
    want        = module.main.name
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.lacpLagPol.content.mode
    want        = "active"
  }

  equal "minLinks" {
    description = "minLinks"
    got         = data.aci_rest_managed.lacpLagPol.content.minLinks
    want        = "2"
  }

  equal "maxLinks" {
    description = "maxLinks"
    got         = data.aci_rest_managed.lacpLagPol.content.maxLinks
    want        = "10"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.lacpLagPol.content.ctrl
    want        = "load-defer,symmetric-hash"
  }
}

data "aci_rest_managed" "l2LoadBalancePol" {
  dn = "${data.aci_rest_managed.lacpLagPol.id}/loadbalanceP"

  depends_on = [module.main]
}

resource "test_assertions" "l2LoadBalancePol" {
  component = "l2LoadBalancePol"

  equal "hashFields" {
    description = "hashFields"
    got         = data.aci_rest_managed.l2LoadBalancePol.content.hashFields
    want        = "src-ip"
  }
}
