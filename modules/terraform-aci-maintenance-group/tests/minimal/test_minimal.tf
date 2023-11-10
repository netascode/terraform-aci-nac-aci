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

data "aci_rest_managed" "maintMaintP" {
  dn = "uni/fabric/maintpol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "maintMaintP" {
  component = "maintMaintP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.maintMaintP.content.name
    want        = module.main.name
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.maintMaintP.content.adminSt
    want        = "untriggered"
  }

  equal "graceful" {
    description = "graceful"
    got         = data.aci_rest_managed.maintMaintP.content.graceful
    want        = "no"
  }

  equal "notifCond" {
    description = "notifCond"
    got         = data.aci_rest_managed.maintMaintP.content.notifCond
    want        = "notifyOnlyOnFailures"
  }

  equal "runMode" {
    description = "runMode"
    got         = data.aci_rest_managed.maintMaintP.content.runMode
    want        = "pauseOnlyOnFailures"
  }
}

data "aci_rest_managed" "maintMaintGrp" {
  dn = "uni/fabric/maintgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "maintMaintGrp" {
  component = "maintMaintGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.maintMaintGrp.content.name
    want        = module.main.name
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.maintMaintGrp.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "maintRsMgrpp" {
  dn = "${data.aci_rest_managed.maintMaintGrp.id}/rsmgrpp"

  depends_on = [module.main]
}

resource "test_assertions" "maintRsMgrpp" {
  component = "maintRsMgrpp"

  equal "tnMaintMaintPName" {
    description = "tnMaintMaintPName"
    got         = data.aci_rest_managed.maintRsMgrpp.content.tnMaintMaintPName
    want        = module.main.name
  }
}
