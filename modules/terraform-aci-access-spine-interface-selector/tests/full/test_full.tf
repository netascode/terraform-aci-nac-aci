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

resource "aci_rest_managed" "infraSpAccPortP" {
  dn         = "uni/infra/spaccportprof-SPINE1001"
  class_name = "infraSpAccPortP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest_managed.infraSpAccPortP.content.name
  name              = "1-2"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
}

data "aci_rest_managed" "infraSHPortS" {
  dn = "uni/infra/spaccportprof-SPINE1001/shports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraSHPortS" {
  component = "infraSHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSHPortS.content.name
    want        = module.main.name
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.infraSHPortS.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "infraRsSpAccGrp" {
  dn = "${data.aci_rest_managed.infraSHPortS.id}/rsspAccGrp"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsSpAccGrp" {
  component = "infraRsSpAccGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsSpAccGrp.content.tDn
    want        = "uni/infra/funcprof/spaccportgrp-ACC1"
  }
}

data "aci_rest_managed" "infraPortBlk" {
  dn = "${data.aci_rest_managed.infraSHPortS.id}/portblk-PB1"

  depends_on = [module.main]
}

resource "test_assertions" "infraPortBlk" {
  component = "infraPortBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraPortBlk.content.name
    want        = "PB1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraPortBlk.content.descr
    want        = "My Description"
  }

  equal "fromCard" {
    description = "fromCard"
    got         = data.aci_rest_managed.infraPortBlk.content.fromCard
    want        = "1"
  }

  equal "fromPort" {
    description = "fromPort"
    got         = data.aci_rest_managed.infraPortBlk.content.fromPort
    want        = "1"
  }

  equal "toCard" {
    description = "toCard"
    got         = data.aci_rest_managed.infraPortBlk.content.toCard
    want        = "1"
  }

  equal "toPort" {
    description = "toPort"
    got         = data.aci_rest_managed.infraPortBlk.content.toPort
    want        = "2"
  }
}
