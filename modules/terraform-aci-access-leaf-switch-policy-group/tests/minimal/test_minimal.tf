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

data "aci_rest_managed" "infraAccNodePGrp" {
  dn = "uni/infra/funcprof/accnodepgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAccNodePGrp" {
  component = "infraAccNodePGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAccNodePGrp.content.name
    want        = module.main.name
  }
}
