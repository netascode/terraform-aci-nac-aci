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

  name = "TEST_MINIMAL"
}

data "aci_rest_managed" "spanDestGrp" {
  dn = "uni/infra/destgrp-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDestGrp.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanDest" {
  dn = "${data.aci_rest_managed.spanDestGrp.id}/dest-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "spanDest" {
  component = "spanDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDest.content.name
    want        = "TEST_MINIMAL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDest.content.descr
    want        = ""
  }
}
