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
  name   = "TEST_GRP_MIN"
}

data "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/fabric/destgrp-TEST_GRP_MIN"
  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "TEST_GRP_MIN"
  }
}
