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

  name        = "TEST_FULL"
  description = "My Filter Group"
  entries = [
    {
      name                  = "HTTP"
      description           = "HTTP Port"
      source_ip             = "1.1.1.1"
      destination_ip        = "2.2.2.2"
      source_from_port      = 2001
      source_to_port        = 2002
      destination_to_port   = "80"
      destination_from_port = "http"
    }
  ]
}

data "aci_rest_managed" "spanFilterGrp" {
  dn = "uni/infra/filtergrp-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "spanFilterGrp" {
  component = "spanFilterGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanFilterGrp.content.name
    want        = "TEST_FULL"
  }
  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanFilterGrp.content.descr
    want        = "My Filter Group"
  }
}

data "aci_rest_managed" "spanFilterEntry" {
  dn = "${data.aci_rest_managed.spanFilterGrp.id}/proto-unspecified-src-[1.1.1.1]-dst-[2.2.2.2]-srcPortFrom-2001-srcPortTo-2002-dstPortFrom-http-dstPortTo-http"

  depends_on = [module.main]
}

resource "test_assertions" "spanFilterEntry" {
  component = "spanFilterEntry"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanFilterEntry.content.name
    want        = "HTTP"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanFilterEntry.content.descr
    want        = "HTTP Port"
  }

  equal "dstAddr" {
    description = "dstAddr"
    got         = data.aci_rest_managed.spanFilterEntry.content.dstAddr
    want        = "2.2.2.2"
  }

  equal "dstPortFrom" {
    description = "dstPortFrom"
    got         = data.aci_rest_managed.spanFilterEntry.content.dstPortFrom
    want        = "http"
  }

  equal "dstPortTo" {
    description = "dstPortTo"
    got         = data.aci_rest_managed.spanFilterEntry.content.dstPortTo
    want        = "http"
  }

  equal "ipProto" {
    description = "ipProto"
    got         = data.aci_rest_managed.spanFilterEntry.content.ipProto
    want        = "unspecified"
  }

  equal "srcAddr" {
    description = "srcAddr"
    got         = data.aci_rest_managed.spanFilterEntry.content.srcAddr
    want        = "1.1.1.1"
  }

  equal "srcPortFrom" {
    description = "srcPortFrom"
    got         = data.aci_rest_managed.spanFilterEntry.content.srcPortFrom
    want        = "2001"
  }

  equal "srcPortTo" {
    description = "srcPortTo"
    got         = data.aci_rest_managed.spanFilterEntry.content.srcPortTo
    want        = "2002"
  }
}
