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
  name        = "TEST_FULL"
  description = "My Test Fabric Span Source Group"
  admin_state = false
  sources = [
    {
      name        = "SRC1"
      description = "Source1"
      direction   = "both"
      span_drop   = false
      tenant      = "TEN1"
      vrf         = "VRF1"
      fabric_paths = [
        {
          node_id = 101
          port    = 49
        }
      ]
    },
    {
      name          = "SRC2"
      tenant        = "TEN1"
      bridge_domain = "BD1"
    }
  ]
  destination_name        = "TEST_DST"
  destination_description = "My Destination"

}

data "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/fabric/srcgrp-TEST_FULL"
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
    want        = "My Test Fabric Span Source Group"
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

  equal "spanOnDrop" {
    description = "spanOnDrop"
    got         = data.aci_rest_managed.spanSrc1.content.spanOnDrop
    want        = "no"
  }
}

data "aci_rest_managed" "spanRsSrcToPathEp_port" {
  dn         = "${data.aci_rest_managed.spanSrc1.id}/rssrcToPathEp-[topology/pod-1/paths-101/pathep-[eth1/49]]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToPathEp_port" {
  component = "spanRsSrcToPathEp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToPathEp_port.content.tDn
    want        = "topology/pod-1/paths-101/pathep-[eth1/49]"
  }
}


data "aci_rest_managed" "spanRsSrcToCtx" {
  dn         = "${data.aci_rest_managed.spanSrc1.id}/rssrcToCtx"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToCtx" {
  component = "spanRsSrcToCtx"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToCtx.content.tDn
    want        = "uni/tn-TEN1/ctx-VRF1"
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

  equal "spanOnDrop" {
    description = "spanOnDrop"
    got         = data.aci_rest_managed.spanSrc2.content.spanOnDrop
    want        = "no"
  }
}

data "aci_rest_managed" "spanRsSrcToBD" {
  dn         = "${data.aci_rest_managed.spanSrc2.id}/rssrcToBD"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToBD" {
  component = "spanRsSrcToBD"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToBD.content.tDn
    want        = "uni/tn-TEN1/BD-BD1"
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
    want        = "My Destination"
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
