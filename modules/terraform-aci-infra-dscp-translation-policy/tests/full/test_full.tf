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

  admin_state   = true
  control_plane = "CS1"
  level_1       = "CS2"
  level_2       = "CS3"
  level_3       = "CS4"
  level_4       = "CS5"
  level_5       = "CS6"
  level_6       = "CS7"
  policy_plane  = "AF11"
  span          = "AF12"
  traceroute    = "AF13"
}

data "aci_rest_managed" "qosDscpTransPol" {
  dn = "uni/tn-infra/dscptranspol-default"

  depends_on = [module.main]
}

resource "test_assertions" "qosDscpTransPol" {
  component = "qosDscpTransPol"

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.qosDscpTransPol.content.adminSt
    want        = "enabled"
  }

  equal "control" {
    description = "control"
    got         = data.aci_rest_managed.qosDscpTransPol.content.control
    want        = "CS1"
  }

  equal "level1" {
    description = "level1"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level1
    want        = "CS2"
  }

  equal "level2" {
    description = "level2"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level2
    want        = "CS3"
  }

  equal "level3" {
    description = "level3"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level3
    want        = "CS4"
  }

  equal "level4" {
    description = "level4"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level4
    want        = "CS5"
  }

  equal "level5" {
    description = "level5"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level5
    want        = "CS6"
  }

  equal "level6" {
    description = "level6"
    got         = data.aci_rest_managed.qosDscpTransPol.content.level6
    want        = "CS7"
  }

  equal "policy" {
    description = "policy"
    got         = data.aci_rest_managed.qosDscpTransPol.content.policy
    want        = "AF11"
  }

  equal "span" {
    description = "span"
    got         = data.aci_rest_managed.qosDscpTransPol.content.span
    want        = "AF12"
  }

  equal "traceroute" {
    description = "traceroute"
    got         = data.aci_rest_managed.qosDscpTransPol.content.traceroute
    want        = "AF13"
  }
}
