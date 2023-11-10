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

  name                    = "SW-PG1"
  forwarding_scale_policy = "HIGH-DUAL-STACK"
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

data "aci_rest_managed" "infraRsTopoctrlFwdScaleProfPol" {
  dn = "${data.aci_rest_managed.infraAccNodePGrp.id}/rstopoctrlFwdScaleProfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsTopoctrlFwdScaleProfPol" {
  component = "infraRsTopoctrlFwdScaleProfPol"

  equal "tnTopoctrlFwdScaleProfilePolName" {
    description = "tnTopoctrlFwdScaleProfilePolName"
    got         = data.aci_rest_managed.infraRsTopoctrlFwdScaleProfPol.content.tnTopoctrlFwdScaleProfilePolName
    want        = "HIGH-DUAL-STACK"
  }
}
