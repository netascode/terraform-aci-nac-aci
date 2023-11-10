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

data "aci_rest_managed" "bgpCtxAfPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bgpCtxAfP-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "bgpCtxAfPol" {
  component = "bgpCtxAfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.descr
    want        = ""
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.ctrl
    want        = ""
  }

  equal "eDist" {
    description = "eDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.eDist
    want        = "20"
  }

  equal "iDist" {
    description = "iDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.iDist
    want        = "200"
  }

  equal "localDist" {
    description = "localDist"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.localDist
    want        = "220"
  }

  equal "maxLocalEcmp" {
    description = "maxLocalEcmp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxLocalEcmp
    want        = "0"
  }

  equal "maxEcmp" {
    description = "maxEcmp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxEcmp
    want        = "16"
  }

  equal "maxEcmpIbgp" {
    description = "maxEcmpIbgp"
    got         = data.aci_rest_managed.bgpCtxAfPol.content.maxEcmpIbgp
    want        = "16"
  }
}
