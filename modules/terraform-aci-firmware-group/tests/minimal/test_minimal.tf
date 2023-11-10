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

  name = "UG1"
}

data "aci_rest_managed" "firmwareFwGrp" {
  dn = "uni/fabric/fwgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "firmwareFwGrp" {
  component = "firmwareFwGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.firmwareFwGrp.content.name
    want        = module.main.name
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.firmwareFwGrp.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "firmwareFwP" {
  dn = "uni/fabric/fwpol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "firmwareFwP" {
  component = "firmwareFwP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.firmwareFwP.content.name
    want        = module.main.name
  }
}
