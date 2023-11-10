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
  name                            = "DST_GRP"
  description                     = "My Tenant SPAN Destination Group"
  destination_tenant              = "ABC"
  destination_application_profile = "AP1"
  destination_endpoint_group      = "EPG1"
  ip                              = "1.1.1.1"
  source_prefix                   = "1.2.3.4/32"
  dscp                            = "CS4"
  flow_id                         = 10
  mtu                             = 9000
  ttl                             = 10
  span_version                    = 2
  enforce_version                 = true
}

data "aci_rest_managed" "spanDestGrp" {
  dn         = "uni/tn-TF/destgrp-DST_GRP"
  depends_on = [module.main]
}

resource "test_assertions" "spanDestGrp" {
  component = "spanDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDestGrp.content.name
    want        = "DST_GRP"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanDestGrp.content.descr
    want        = "My Tenant SPAN Destination Group"
  }
}

data "aci_rest_managed" "spanDest" {
  dn         = "${data.aci_rest_managed.spanDestGrp.id}/dest-DST_GRP"
  depends_on = [module.main]
}

resource "test_assertions" "spanDest" {
  component = "spanDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanDest.content.name
    want        = "DST_GRP"
  }
}

data "aci_rest_managed" "spanRsDestEpg" {
  dn         = "${data.aci_rest_managed.spanDest.id}/rsdestEpg"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsDestEpg" {
  component = "spanRsDestEpg"

  equal "dscp" {
    description = "dscp"
    got         = data.aci_rest_managed.spanRsDestEpg.content.dscp
    want        = "CS4"
  }

  equal "flowId" {
    description = "flowId"
    got         = data.aci_rest_managed.spanRsDestEpg.content.flowId
    want        = "10"
  }

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ip
    want        = "1.1.1.1"
  }

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.spanRsDestEpg.content.mtu
    want        = "9000"
  }

  equal "srcIpPrefix" {
    description = "srcIpPrefix"
    got         = data.aci_rest_managed.spanRsDestEpg.content.srcIpPrefix
    want        = "1.2.3.4/32"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsDestEpg.content.tDn
    want        = "uni/tn-ABC/ap-AP1/epg-EPG1"
  }

  equal "ttl" {
    description = "ttl"
    got         = data.aci_rest_managed.spanRsDestEpg.content.ttl
    want        = "10"
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
}
