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

  name = "SIPG1"
}

data "aci_rest_managed" "infraSpAccPortGrp" {
  dn = "uni/infra/funcprof/spaccportgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpAccPortGrp" {
  component = "infraSpAccPortGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSpAccPortGrp.content.name
    want        = module.main.name
  }
}
