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

  name                = "POL1"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}

data "aci_rest_managed" "fabricSpNodePGrp" {
  dn = "uni/fabric/funcprof/spnodepgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSpNodePGrp" {
  component = "fabricSpNodePGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricSpNodePGrp.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricRsPsuInstPol" {
  dn = "${data.aci_rest_managed.fabricSpNodePGrp.id}/rspsuInstPol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsPsuInstPol" {
  component = "fabricRsPsuInstPol"

  equal "tnPsuInstPolName" {
    description = "tnPsuInstPolName"
    got         = data.aci_rest_managed.fabricRsPsuInstPol.content.tnPsuInstPolName
    want        = "PSU1"
  }
}

data "aci_rest_managed" "fabricRsNodeCtrl" {
  dn = "${data.aci_rest_managed.fabricSpNodePGrp.id}/rsnodeCtrl"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsNodeCtrl" {
  component = "fabricRsNodeCtrl"

  equal "tnFabricNodeControlName" {
    description = "tnFabricNodeControlName"
    got         = data.aci_rest_managed.fabricRsNodeCtrl.content.tnFabricNodeControlName
    want        = "NC1"
  }
}
