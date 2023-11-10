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

  name                = "TEST_EPG"
  ip                  = "1.1.1.1"
  source_prefix       = "2.2.2.2"
  dscp                = "CS0"
  mtu                 = 9000
  ttl                 = 16
  span_version        = 2
  enforce_version     = true
  tenant              = "TEN1"
  application_profile = "APP1"
  endpoint_group      = "EPG1"
}

data "aci_rest_managed" "spanDestGrp" {
  dn = "uni/infra/destgrp-TEST_EPG"

  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "TEST_EPG"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDestGrp.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanDest" {
  dn = "${data.aci_rest_managed.spanDestGrp.id}/dest-TEST_EPG"

  depends_on = [module.main]
}

resource "test_assertions" "spanDest" {
  component = "spanDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDest.content.name
    want        = "TEST_EPG"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDest.content.descr
    want        = ""
  }
}

data "aci_rest_managed" "spanRsDestEpg" {
  dn = "${data.aci_rest_managed.spanDest.id}/rsdestEpg"

  depends_on = [module.main]
}

resource "test_assertions" "spanRsDestEpg" {
  component = "spanRsDestEpg"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ip
    want        = "1.1.1.1"
  }

  equal "srcIpPrefix" {
    description = "srcIpPrefix"
    got         = data.aci_rest_managed.spanRsDestEpg.content.srcIpPrefix
    want        = "2.2.2.2"
  }

  equal "dscp" {
    description = "dscp"
    got         = data.aci_rest_managed.spanRsDestEpg.content.dscp
    want        = "CS0"
  }

  equal "flowId" {
    description = "flowId"
    got         = data.aci_rest_managed.spanRsDestEpg.content.flowId
    want        = "1"
  }

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.spanRsDestEpg.content.mtu
    want        = "9000"
  }

  equal "ttl" {
    description = "ttl"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ttl
    want        = "16"
  }

  equal "ver" {
    description = "ver"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ver
    want        = "ver2"
  }

  equal "verEnforced" {
    description = "verEnforced"
    got         = data.aci_rest_managed.spanRsDestEpg.content.verEnforced
    want        = "yes"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsDestEpg.content.tDn
    want        = "uni/tn-TEN1/ap-APP1/epg-EPG1"
  }
}
