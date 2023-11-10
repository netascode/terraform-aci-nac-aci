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

  tenant               = aci_rest_managed.fvTenant.content.name
  name                 = "BFD-MHOP"
  description          = "My Description"
  detection_multiplier = 10
  min_rx_interval      = 300
  min_tx_interval      = 300
}


data "aci_rest_managed" "bfdMhNodePol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/bfdMhNodePol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bfdMhNodePol" {
  component = "bfdMhNodePol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.bfdMhNodePol.content.name
    want        = "BFD-MHOP"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.bfdMhNodePol.content.descr
    want        = "My Description"
  }

  equal "detectMult" {
    description = "detectMult"
    got         = data.aci_rest_managed.bfdMhNodePol.content.detectMult
    want        = "10"
  }

  equal "minRxIntvl" {
    description = "minRxIntvl"
    got         = data.aci_rest_managed.bfdMhNodePol.content.minRxIntvl
    want        = "300"
  }

  equal "minTxIntvl" {
    description = "minTxIntvl"
    got         = data.aci_rest_managed.bfdMhNodePol.content.minTxIntvl
    want        = "300"
  }
}
