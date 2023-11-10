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

  name             = "L2POL1"
  vlan_scope       = "portlocal"
  qinq             = "edgePort"
  reflective_relay = true
}

data "aci_rest_managed" "l2IfPol" {
  dn = "uni/infra/l2IfP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "l2IfPol" {
  component = "l2IfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.l2IfPol.content.name
    want        = module.main.name
  }

  equal "vlanScope" {
    description = "vlanScope"
    got         = data.aci_rest_managed.l2IfPol.content.vlanScope
    want        = "portlocal"
  }

  equal "qinq" {
    description = "qinq"
    got         = data.aci_rest_managed.l2IfPol.content.qinq
    want        = "edgePort"
  }

  equal "vepa" {
    description = "vepa"
    got         = data.aci_rest_managed.l2IfPol.content.vepa
    want        = "enabled"
  }
}
