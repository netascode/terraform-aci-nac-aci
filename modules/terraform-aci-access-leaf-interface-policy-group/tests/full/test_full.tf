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

  name                       = "VPC1"
  description                = "VPC Interface Policy Group 1"
  type                       = "vpc"
  link_level_policy          = "10G"
  cdp_policy                 = "CDP-ON"
  lldp_policy                = "LLDP-OFF"
  spanning_tree_policy       = "BPDU-GUARD"
  mcp_policy                 = "MCP-ON"
  l2_policy                  = "PORT-LOCAL"
  storm_control_policy       = "10P"
  port_channel_policy        = "LACP"
  port_channel_member_policy = "FAST"
  aaep                       = "AAEP1"
}

data "aci_rest_managed" "infraAccGrp" {
  dn = "uni/infra/funcprof/accbundle-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAccGrp" {
  component = "infraAccGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAccGrp.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraAccGrp.content.descr
    want        = "VPC Interface Policy Group 1"
  }

  equal "lagT" {
    description = "lagT"
    got         = data.aci_rest_managed.infraAccGrp.content.lagT
    want        = "node"
  }
}

data "aci_rest_managed" "infraRsHIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rshIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsHIfPol" {
  component = "infraRsHIfPol"

  equal "tnFabricHIfPolName" {
    description = "tnFabricHIfPolName"
    got         = data.aci_rest_managed.infraRsHIfPol.content.tnFabricHIfPolName
    want        = "10G"
  }
}

data "aci_rest_managed" "infraRsCdpIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rscdpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsCdpIfPol" {
  component = "infraRsCdpIfPol"

  equal "tnCdpIfPolName" {
    description = "tnCdpIfPolName"
    got         = data.aci_rest_managed.infraRsCdpIfPol.content.tnCdpIfPolName
    want        = "CDP-ON"
  }
}

data "aci_rest_managed" "infraRsLldpIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rslldpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsLldpIfPol" {
  component = "infraRsLldpIfPol"

  equal "tnLldpIfPolName" {
    description = "tnLldpIfPolName"
    got         = data.aci_rest_managed.infraRsLldpIfPol.content.tnLldpIfPolName
    want        = "LLDP-OFF"
  }
}

data "aci_rest_managed" "infraRsStpIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rsstpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsStpIfPol" {
  component = "infraRsStpIfPol"

  equal "tnStpIfPolName" {
    description = "tnStpIfPolName"
    got         = data.aci_rest_managed.infraRsStpIfPol.content.tnStpIfPolName
    want        = "BPDU-GUARD"
  }
}

data "aci_rest_managed" "infraRsMcpIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rsmcpIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsMcpIfPol" {
  component = "infraRsMcpIfPol"

  equal "tnMcpIfPolName" {
    description = "tnMcpIfPolName"
    got         = data.aci_rest_managed.infraRsMcpIfPol.content.tnMcpIfPolName
    want        = "MCP-ON"
  }
}

data "aci_rest_managed" "infraRsL2IfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rsl2IfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsL2IfPol" {
  component = "infraRsL2IfPol"

  equal "tnL2IfPolName" {
    description = "tnL2IfPolName"
    got         = data.aci_rest_managed.infraRsL2IfPol.content.tnL2IfPolName
    want        = "PORT-LOCAL"
  }
}

data "aci_rest_managed" "infraRsStormctrlIfPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rsstormctrlIfPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsStormctrlIfPol" {
  component = "infraRsStormctrlIfPol"

  equal "tnStormctrlIfPolName" {
    description = "tnStormctrlIfPolName"
    got         = data.aci_rest_managed.infraRsStormctrlIfPol.content.tnStormctrlIfPolName
    want        = "10P"
  }
}

data "aci_rest_managed" "infraRsLacpPol" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rslacpPol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsLacpPol" {
  component = "infraRsLacpPol"

  equal "tnLacpLagPolName" {
    description = "tnLacpLagPolName"
    got         = data.aci_rest_managed.infraRsLacpPol.content.tnLacpLagPolName
    want        = "LACP"
  }
}

data "aci_rest_managed" "infraAccBndlSubgrp" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/accsubbndl-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAccBndlSubgrp" {
  component = "infraAccBndlSubgrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAccBndlSubgrp.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraRsLacpInterfacePol" {
  dn = "${data.aci_rest_managed.infraAccBndlSubgrp.id}/rslacpInterfacePol"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsLacpInterfacePol" {
  component = "infraRsLacpInterfacePol"

  equal "tnLacpIfPolName" {
    description = "tnLacpIfPolName"
    got         = data.aci_rest_managed.infraRsLacpInterfacePol.content.tnLacpIfPolName
    want        = "FAST"
  }
}

data "aci_rest_managed" "infraRsAttEntP" {
  dn = "${data.aci_rest_managed.infraAccGrp.id}/rsattEntP"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsAttEntP" {
  component = "infraRsAttEntP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsAttEntP.content.tDn
    want        = "uni/infra/attentp-AAEP1"
  }
}
