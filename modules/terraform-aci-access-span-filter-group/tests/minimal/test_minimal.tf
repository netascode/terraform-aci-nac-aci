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

  name = "TEST_MINIMAL"
}

data "aci_rest_managed" "spanFilterGrp" {
  dn = "uni/infra/filtergrp-TEST_MINIMAL"

  depends_on = [module.main]
}

resource "test_assertions" "spanFilterGrp" {
  component = "spanFilterGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanFilterGrp.content.name
    want        = "TEST_MINIMAL"
  }
  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanFilterGrp.content.descr
    want        = ""
  }
}
