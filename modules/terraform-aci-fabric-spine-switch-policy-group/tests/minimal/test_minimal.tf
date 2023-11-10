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

  name = "POL1"
}

data "aci_rest_managed" "fabricSpNodePGrp" {
  dn = "uni/fabric/funcprof/spnodepgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSpNodePGrp" {
  component = "fabricSpNodePGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricSpNodePGrp.content.name
    want        = module.main.name
  }
}
