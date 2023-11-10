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

  name = "SW-PG1"
}

data "aci_rest_managed" "infraSpineAccNodePGrp" {
  dn = "uni/infra/funcprof/spaccnodepgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineAccNodePGrp" {
  component = "infraSpineAccNodePGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpineAccNodePGrp.content.name
    want        = module.main.name
  }
}
