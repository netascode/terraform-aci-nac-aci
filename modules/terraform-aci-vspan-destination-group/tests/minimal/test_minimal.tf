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
  name   = "TEST_GRP_MIN"
}

data "aci_rest_managed" "spanVDestGrp" {
  dn         = "uni/infra/vdestgrp-TEST_GRP_MIN"
  depends_on = [module.main]
}

resource "test_assertions" "spanVDestGrp" {
  component = "spanVDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVDestGrp.content.name
    want        = "TEST_GRP_MIN"
  }
}
