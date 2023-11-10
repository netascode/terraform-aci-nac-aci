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

  name = "POD1-2"
  selectors = [{
    name         = "SEL1"
    policy_group = "POD1-2"
    pod_blocks = [{
      name = "PB1"
      from = 1
      to   = 2
    }]
  }]
}

data "aci_rest_managed" "fabricPodP" {
  dn = "uni/fabric/podprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodP" {
  component = "fabricPodP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricPodS" {
  dn = "${data.aci_rest_managed.fabricPodP.id}/pods-SEL1-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodS" {
  component = "fabricPodS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodS.content.name
    want        = "SEL1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.fabricPodS.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "fabricRsPodPGrp" {
  dn = "${data.aci_rest_managed.fabricPodS.id}/rspodPGrp"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsPodPGrp" {
  component = "fabricRsPodPGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fabricRsPodPGrp.content.tDn
    want        = "uni/fabric/funcprof/podpgrp-POD1-2"
  }
}

data "aci_rest_managed" "fabricPodBlk" {
  dn = "${data.aci_rest_managed.fabricPodS.id}/podblk-PB1"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodBlk" {
  component = "fabricPodBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodBlk.content.name
    want        = "PB1"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest_managed.fabricPodBlk.content.from_
    want        = "1"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest_managed.fabricPodBlk.content.to_
    want        = "2"
  }
}
