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

  admin_state         = true
  per_vlan            = true
  initial_delay       = 200
  key                 = "$ECRETKEY1"
  loop_detection      = 5
  disable_port_action = true
  frequency_sec       = 0
  frequency_msec      = 100
}

data "aci_rest_managed" "mcpInstPol" {
  dn = "uni/infra/mcpInstP-default"

  depends_on = [module.main]
}

resource "test_assertions" "mcpInstPol" {
  component = "mcpInstPol"

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.mcpInstPol.content.adminSt
    want        = "enabled"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.mcpInstPol.content.ctrl
    want        = "pdu-per-vlan"
  }

  equal "initDelayTime" {
    description = "initDelayTime"
    got         = data.aci_rest_managed.mcpInstPol.content.initDelayTime
    want        = "200"
  }

  equal "loopDetectMult" {
    description = "loopDetectMult"
    got         = data.aci_rest_managed.mcpInstPol.content.loopDetectMult
    want        = "5"
  }

  equal "loopProtectAct" {
    description = "loopProtectAct"
    got         = data.aci_rest_managed.mcpInstPol.content.loopProtectAct
    want        = "port-disable"
  }

  equal "txFreq" {
    description = "txFreq"
    got         = data.aci_rest_managed.mcpInstPol.content.txFreq
    want        = "0"
  }

  equal "txFreqMsec" {
    description = "txFreqMsec"
    got         = data.aci_rest_managed.mcpInstPol.content.txFreqMsec
    want        = "100"
  }
}
