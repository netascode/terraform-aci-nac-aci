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

  name    = "TEST_PATH_CHANNEL"
  mtu     = 9000
  node_id = 101
  channel = "PC1"
}

data "aci_rest_managed" "spanDestGrp" {
  dn = "uni/infra/destgrp-TEST_PATH_CHANNEL"

  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "TEST_PATH_CHANNEL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDestGrp.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanDest" {
  dn = "${data.aci_rest_managed.spanDestGrp.id}/dest-TEST_PATH_CHANNEL"

  depends_on = [module.main]
}

resource "test_assertions" "spanDest" {
  component = "spanDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDest.content.name
    want        = "TEST_PATH_CHANNEL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDest.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanRsDestPathEp" {
  dn = "${data.aci_rest_managed.spanDest.id}/rsdestPathEp-[topology/pod-1/paths-101/pathep-[PC1]]"

  depends_on = [module.main]
}

resource "test_assertions" "spanRsDestPathEp" {
  component = "spanRsDestPathEp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsDestPathEp.content.tDn
    want        = "topology/pod-1/paths-101/pathep-[PC1]"
  }
}
