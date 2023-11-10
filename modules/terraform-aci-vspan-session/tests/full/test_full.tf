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

  name                    = "SESSION1"
  description             = "VSPAN Session 1"
  admin_state             = true
  destination_name        = "DST_GRP1"
  destination_description = "Destination Group 1"
  sources = [
    {
      description         = "Source 1"
      name                = "SRC1"
      direction           = "both"
      tenant              = "TENANT-1"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      endpoint            = "01:23:45:67:89:AB"
      access_paths = [
        {
          node_id = 101
          port    = 3
        }
      ]
    },
    {
      description         = "Source 2"
      name                = "SRC2"
      direction           = "in"
      tenant              = "TENANT-2"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
      access_paths = [
        {
          node_id  = 101
          node2_id = 102
          fex_id   = 151
          fex2_id  = 152
          channel  = "VPC1"
        },
        {
          node_id = 101
          fex_id  = 151
          channel = "PC1"
        },
        {
          node_id = 101
          fex_id  = 151
          port    = 1
        }
      ]
    }
  ]
}

data "aci_rest_managed" "spanVSrcGrp" {
  dn = "uni/infra/vsrcgrp-SESSION1"

  depends_on = [module.main]
}

resource "test_assertions" "spanVSrcGrp" {
  component = "spanVSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVSrcGrp.content.name
    want        = "SESSION1"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanVSrcGrp.content.adminSt
    want        = "start"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanVSrcGrp.content.descr
    want        = "VSPAN Session 1"
  }
}

data "aci_rest_managed" "spanSpanLbl" {
  dn = "${data.aci_rest_managed.spanVSrcGrp.id}/spanlbl-DST_GRP1"

  depends_on = [module.main]
}

resource "test_assertions" "spanSpanLbl" {
  component = "spanSpanLbl"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.name
    want        = "DST_GRP1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSpanLbl.content.descr
    want        = "Destination Group 1"
  }

  equal "tag" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.tag
    want        = "yellow-green"
  }
}


data "aci_rest_managed" "spanVSrc1" {
  dn = "${data.aci_rest_managed.spanVSrcGrp.id}/vsrc-SRC1"

  depends_on = [module.main]
}

resource "test_assertions" "spanVSrc1" {
  component = "spanVSrc1"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVSrc1.content.name
    want        = "SRC1"
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanVSrc1.content.dir
    want        = "both"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanVSrc1.content.descr
    want        = "Source 1"
  }
}

data "aci_rest_managed" "spanRsSrcToVPort" {
  dn = "${data.aci_rest_managed.spanVSrc1.id}/rssrcToVPort-[uni/tn-TENANT-1/ap-AP1/epg-EPG1/cep-01:23:45:67:89:AB]"

  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToVPort" {
  component = "spanRsSrcToVPort"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToVPort.content.tDn
    want        = "uni/tn-TENANT-1/ap-AP1/epg-EPG1/cep-01:23:45:67:89:AB"
  }
}

data "aci_rest_managed" "spanRsSrcToPathEp_port" {
  dn         = "${data.aci_rest_managed.spanVSrc1.id}/rssrcToPathEp-[topology/pod-1/paths-101/pathep-[eth1/3]]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToPathEp_port" {
  component = "spanRsSrcToPathEp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToPathEp_port.content.tDn
    want        = "topology/pod-1/paths-101/pathep-[eth1/3]"
  }
}



data "aci_rest_managed" "spanVSrc2" {
  dn = "uni/infra/vsrcgrp-SESSION1/vsrc-SRC2"

  depends_on = [module.main]
}

resource "test_assertions" "spanVSrc2" {
  component = "spanVSrc2"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanVSrc2.content.name
    want        = "SRC2"
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanVSrc2.content.dir
    want        = "in"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanVSrc2.content.descr
    want        = "Source 2"
  }
}

data "aci_rest_managed" "spanRsSrcToEpg" {
  dn         = "${data.aci_rest_managed.spanVSrc2.id}/rssrcToEpg"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToEpg" {
  component = "spanRsSrcToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToEpg.content.tDn
    want        = "uni/tn-TENANT-2/ap-AP1/epg-EPG1"
  }
}

data "aci_rest_managed" "spanRsSrcToPathEp_fex_channel1" {
  dn         = "${data.aci_rest_managed.spanVSrc2.id}/rssrcToPathEp-[topology/pod-1/paths-101/extpaths-151/pathep-[PC1]]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToPathEp_fex_channel1" {
  component = "spanRsSrcToPathEp_fex_channel1"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToPathEp_fex_channel1.content.tDn
    want        = "topology/pod-1/paths-101/extpaths-151/pathep-[PC1]"
  }
}

data "aci_rest_managed" "spanRsSrcToPathEp_fex_channel2" {
  dn         = "${data.aci_rest_managed.spanVSrc2.id}/rssrcToPathEp-[topology/pod-1/protpaths-101-102/extprotpaths-151-152/pathep-[VPC1]]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToPathEp_fex_channel2" {
  component = "spanRsSrcToPathEp_fex_channel2"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToPathEp_fex_channel2.content.tDn
    want        = "topology/pod-1/protpaths-101-102/extprotpaths-151-152/pathep-[VPC1]"
  }
}

data "aci_rest_managed" "spanRsSrcToPathEp_fex_port" {
  dn         = "${data.aci_rest_managed.spanVSrc2.id}/rssrcToPathEp-[topology/pod-1/paths-101/extpaths-151/pathep-[eth1/1]]"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToPathEp_fex_port" {
  component = "spanRsSrcToPathEp_fex_port"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToPathEp_fex_port.content.tDn
    want        = "topology/pod-1/paths-101/extpaths-151/pathep-[eth1/1]"
  }
}
