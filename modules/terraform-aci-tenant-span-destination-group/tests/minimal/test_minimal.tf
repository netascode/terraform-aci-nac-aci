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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                          = aci_rest_managed.fvTenant.content.name
  name                            = "TEST_GRP_MIN"
  destination_application_profile = "AP1"
  destination_endpoint_group      = "EPG1"
  ip                              = "1.1.1.1"
  source_prefix                   = "1.2.3.4/32"
}

data "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/tn-TF/destgrp-TEST_GRP_MIN"
  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "TEST_GRP_MIN"
  }
}

data "aci_rest_managed" "spanRsDestEpg" {
  dn         = "${data.aci_rest_managed.spanDestGrp.id}/dest-TEST_GRP_MIN/rsdestEpg"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsDestEpg" {
  component = "spanRsDestEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsDestEpg.content.tDn
    want        = "uni/tn-TF/ap-AP1/epg-EPG1"
  }
  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ip
    want        = "1.1.1.1"
  }

  equal "srcIpPrefix" {
    description = "srcIpPrefix"
    got         = data.aci_rest_managed.spanRsDestEpg.content.srcIpPrefix
    want        = "1.2.3.4/32"
  }
}
