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

  name               = "LEAF101"
  interface_profiles = ["PROF1"]
  selectors = [{
    name         = "SEL1"
    policy_group = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 101
      to   = 101
    }]
  }]
}

data "aci_rest_managed" "fabricLeafP" {
  dn = "uni/fabric/leprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeafP" {
  component = "fabricLeafP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricLeafP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricLeafS" {
  dn = "${data.aci_rest_managed.fabricLeafP.id}/leaves-SEL1-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeafS" {
  component = "fabricLeafS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricLeafS.content.name
    want        = "SEL1"
  }
}

data "aci_rest_managed" "fabricRsLeNodePGrp" {
  dn = "${data.aci_rest_managed.fabricLeafS.id}/rsleNodePGrp"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsLeNodePGrp" {
  component = "fabricRsLeNodePGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fabricRsLeNodePGrp.content.tDn
    want        = "uni/fabric/funcprof/lenodepgrp-POL1"
  }
}

data "aci_rest_managed" "fabricNodeBlk" {
  dn = "${data.aci_rest_managed.fabricLeafS.id}/nodeblk-BLOCK1"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodeBlk" {
  component = "fabricNodeBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricNodeBlk.content.name
    want        = "BLOCK1"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest_managed.fabricNodeBlk.content.from_
    want        = "101"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest_managed.fabricNodeBlk.content.to_
    want        = "101"
  }
}

data "aci_rest_managed" "fabricRsLePortP" {
  dn = "${data.aci_rest_managed.fabricLeafP.id}/rslePortP-[uni/fabric/leportp-PROF1]"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsLePortP" {
  component = "fabricRsLePortP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fabricRsLePortP.content.tDn
    want        = "uni/fabric/leportp-PROF1"
  }
}
