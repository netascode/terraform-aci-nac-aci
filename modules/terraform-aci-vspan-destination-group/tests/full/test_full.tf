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
  source      = "../.."
  name        = "TEST_GRP"
  description = "My VSPAN TEST Destination Group"
  destinations = [
    {
      name        = "DST1"
      description = "Destination 1"
      ip          = "1.2.3.4"
      dscp        = "CS4"
      flow_id     = 10
      mtu         = 9000
      ttl         = 10
    },
    {
      name                = "DST2"
      description         = "Destination 2"
      tenant              = "Tenant-1"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      endpoint            = "01:23:45:67:89:AB"
    }
  ]
}

data "aci_rest_managed" "spanVDestGrp" {
  dn         = "uni/infra/vdestgrp-TEST_GRP"
  depends_on = [module.main]
}

resource "test_assertions" "spanVDestGrp" {
  component = "spanVDestGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVDestGrp.content.name
    want        = "TEST_GRP"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanVDestGrp.content.descr
    want        = "My VSPAN TEST Destination Group"
  }
}

data "aci_rest_managed" "spanVDest1" {
  dn         = "${data.aci_rest_managed.spanVDestGrp.id}/vdest-DST1"
  depends_on = [module.main]
}

resource "test_assertions" "spanVDest1" {
  component = "spanVDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVDest1.content.name
    want        = "DST1"
  }

  equal "description" {
    description = "descr"
    got         = data.aci_rest_managed.spanVDest1.content.descr
    want        = "Destination 1"
  }
}

data "aci_rest_managed" "spanVDest2" {
  dn         = "${data.aci_rest_managed.spanVDestGrp.id}/vdest-DST2"
  depends_on = [module.main]
}

resource "test_assertions" "spanVDest2" {
  component = "spanVDest"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVDest2.content.name
    want        = "DST2"
  }

  equal "description" {
    description = "descr"
    got         = data.aci_rest_managed.spanVDest2.content.descr
    want        = "Destination 2"
  }
}

data "aci_rest_managed" "spanRsDestToVPort" {
  dn         = "${data.aci_rest_managed.spanVDest2.id}/rsdestToVPort-[uni/tn-Tenant-1/ap-AP1/epg-EPG1/cep-01:23:45:67:89:AB]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsDestToVPort" {
  component = "spanRsDestToVPort"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsDestToVPort.content.tDn
    want        = "uni/tn-Tenant-1/ap-AP1/epg-EPG1/cep-01:23:45:67:89:AB"
  }
}


data "aci_rest_managed" "spanVEpgSummary" {
  dn         = "${data.aci_rest_managed.spanVDest1.id}/vepgsummary"
  depends_on = [module.main]
}

resource "test_assertions" "spanVEpgSummary" {
  component = "spanVEpgSummary"

  equal "dstIp" {
    description = "dstIp"
    got         = data.aci_rest_managed.spanVEpgSummary.content.dstIp
    want        = "1.2.3.4"
  }

  equal "dscp" {
    description = "dscp"
    got         = data.aci_rest_managed.spanVEpgSummary.content.dscp
    want        = "CS4"
  }

  equal "flowId" {
    description = "flowId"
    got         = data.aci_rest_managed.spanVEpgSummary.content.flowId
    want        = "10"
  }

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.spanVEpgSummary.content.mtu
    want        = "9000"
  }

  equal "srcIpPrefix" {
    description = "srcIpPrefix"
    got         = data.aci_rest_managed.spanVEpgSummary.content.srcIpPrefix
    want        = "0.0.0.0"
  }

  equal "ttl" {
    description = "ttl"
    got         = data.aci_rest_managed.spanVEpgSummary.content.ttl
    want        = "10"
  }
}
