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

  name             = "SESSION2"
  destination_name = "DEST1"
}

data "aci_rest_managed" "spanVSrcGrp" {
  dn = "uni/infra/vsrcgrp-SESSION2"

  depends_on = [module.main]
}

resource "test_assertions" "spanVSrcGrp" {
  component = "spanVSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVSrcGrp.content.name
    want        = "SESSION2"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanVSrcGrp.content.adminSt
    want        = "start"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanVSrcGrp.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanSpanLbl" {
  dn = "${data.aci_rest_managed.spanVSrcGrp.id}/spanlbl-DEST1"

  depends_on = [module.main]
}

resource "test_assertions" "spanSpanLbl" {
  component = "spanSpanLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.name
    want        = "DEST1"
  }
}
