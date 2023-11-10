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

  name               = "SPINE1001"
  interface_profiles = ["SPINE1001"]
  selectors = [{
    name         = "SEL1"
    policy_group = "IPG1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}

data "aci_rest_managed" "infraSpineP" {
  dn = "uni/infra/spprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineP" {
  component = "infraSpineP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpineP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraSpineS" {
  dn = "${data.aci_rest_managed.infraSpineP.id}/spines-SEL1-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineS" {
  component = "infraSpineS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpineS.content.name
    want        = "SEL1"
  }
}

data "aci_rest_managed" "infraRsSpineAccNodePGrp" {
  dn = "${data.aci_rest_managed.infraSpineS.id}/rsspineAccNodePGrp"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsSpineAccNodePGrp" {
  component = "infraRsSpineAccNodePGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsSpineAccNodePGrp.content.tDn
    want        = "uni/infra/funcprof/spaccnodepgrp-IPG1"
  }
}

data "aci_rest_managed" "infraNodeBlk" {
  dn = "${data.aci_rest_managed.infraSpineS.id}/nodeblk-BLOCK1"

  depends_on = [module.main]
}

resource "test_assertions" "infraNodeBlk" {
  component = "infraNodeBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraNodeBlk.content.name
    want        = "BLOCK1"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest_managed.infraNodeBlk.content.from_
    want        = "1001"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest_managed.infraNodeBlk.content.to_
    want        = "1001"
  }
}

data "aci_rest_managed" "infraRsSpAccPortP" {
  dn = "${data.aci_rest_managed.infraSpineP.id}/rsspAccPortP-[uni/infra/spaccportprof-SPINE1001]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsSpAccPortP" {
  component = "infraRsSpAccPortP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsSpAccPortP.content.tDn
    want        = "uni/infra/spaccportprof-SPINE1001"
  }
}
