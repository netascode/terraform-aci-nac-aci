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

  name = "POD1"
}

data "aci_rest_managed" "fabricPodPGrp" {
  dn = "uni/fabric/funcprof/podpgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodPGrp" {
  component = "fabricPodPGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodPGrp.content.name
    want        = module.main.name
  }
}
