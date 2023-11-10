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

module "main" {
  source = "../.."

  preserve_cos = true
}

data "aci_rest_managed" "qosInstPol" {
  dn = "uni/infra/qosinst-default"

  depends_on = [module.main]
}

resource "test_assertions" "qosInstPol" {
  component = "qosInstPol"

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.qosInstPol.content.ctrl
    want        = "dot1p-preserve"
  }
}
