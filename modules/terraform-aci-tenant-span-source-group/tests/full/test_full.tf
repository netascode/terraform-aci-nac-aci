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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "TEST_FULL"
  description = "My Test Tenant Span Source Group"
  admin_state = false
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      span_drop           = false
      application_profile = "AP1"
      endpoint_group      = "EPG1"
    },
    {
      name = "SRC2"
    }
  ]
  destination = "TEST_DST"
}

data "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/tn-TF/srcgrp-TEST_FULL"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrcGrp" {
  component = "spanSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrcGrp.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrcGrp.content.descr
    want        = "My Test Tenant Span Source Group"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanSrcGrp.content.adminSt
    want        = "disabled"
  }
}

data "aci_rest_managed" "spanSrc1" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/src-SRC1"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrc1" {
  component = "spanSrc1"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrc1.content.name
    want        = "SRC1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrc1.content.descr
    want        = "Source1"
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanSrc1.content.dir
    want        = "both"
  }

}



data "aci_rest_managed" "spanRsSrcToEpg" {
  dn         = "${data.aci_rest_managed.spanSrc1.id}/rssrcToEpg"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToEpg" {
  component = "spanRsSrcToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToEpg.content.tDn
    want        = "uni/tn-TF/ap-AP1/epg-EPG1"
  }
}

data "aci_rest_managed" "spanSrc2" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/src-SRC2"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrc2" {
  component = "spanSrc2"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrc2.content.name
    want        = "SRC2"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrc2.content.descr
    want        = ""
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanSrc2.content.dir
    want        = "both"
  }
}

data "aci_rest_managed" "spanSpanLbl" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/spanlbl-TEST_DST"
  depends_on = [module.main]
}

resource "test_assertions" "spanSpanLbl" {
  component = "spanSpanLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.name
    want        = "TEST_DST"
  }
}
