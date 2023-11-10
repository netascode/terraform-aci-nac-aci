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
  source           = "../.."
  name             = "TEST_MIN"
  destination_name = "TEST_DST"

}

data "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/fabric/srcgrp-TEST_MIN"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrcGrp" {
  component = "spanSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrcGrp.content.name
    want        = "TEST_MIN"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrcGrp.content.descr
    want        = ""
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanSrcGrp.content.adminSt
    want        = "enabled"
  }
}


data "aci_rest_managed" "spanSpanLbl" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/spanlbl-TEST_DST"
  depends_on = [module.main]
}

resource "test_assertions" "spanSpanLbl" {
  component = "spanSpanLbl"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSpanLbl.content.descr
    want        = ""
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.name
    want        = "TEST_DST"
  }

  equal "tag" {
    description = "tag"
    got         = data.aci_rest_managed.spanSpanLbl.content.tag
    want        = "yellow-green"
  }
}
