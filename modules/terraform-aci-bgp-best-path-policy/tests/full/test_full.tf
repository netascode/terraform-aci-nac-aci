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

  name         = "TEST_FULL"
  tenant       = aci_rest_managed.fvTenant.content.name
  description  = "My BGP Best Path Policy"
  control_type = "multi-path-relax"
}

data "aci_rest_managed" "bgpBestPathCtrlPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bestpath-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "bgpBestPathCtrlPol" {
  component = "bgpBestPathCtrlPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpBestPathCtrlPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpBestPathCtrlPol.content.descr
    want        = "My BGP Best Path Policy"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.bgpBestPathCtrlPol.content.ctrl
    want        = "asPathMultipathRelax"
  }
}
