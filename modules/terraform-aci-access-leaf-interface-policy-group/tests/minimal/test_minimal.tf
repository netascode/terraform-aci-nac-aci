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

  name = "AP1"
}

data "aci_rest_managed" "infraAccGrp" {
  dn = "uni/infra/funcprof/accportgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAccGrp" {
  component = "infraAccGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAccGrp.content.name
    want        = module.main.name
  }
}
