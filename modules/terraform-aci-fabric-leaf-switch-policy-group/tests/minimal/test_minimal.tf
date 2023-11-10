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

  name = "LEAFS"
}

data "aci_rest_managed" "fabricLeNodePGrp" {
  dn = "uni/fabric/funcprof/lenodepgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeNodePGrp" {
  component = "fabricLeNodePGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricLeNodePGrp.content.name
    want        = module.main.name
  }
}
