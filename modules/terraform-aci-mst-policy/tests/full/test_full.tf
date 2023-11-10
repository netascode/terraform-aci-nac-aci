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

  name     = "MST1"
  region   = "REG1"
  revision = 1
  instances = [{
    name = "INST1"
    id   = 1
    vlan_ranges = [{
      from = 10
      to   = 20
    }]
  }]
}

data "aci_rest_managed" "stpMstRegionPol" {
  dn = "uni/infra/mstpInstPol-default/mstpRegionPol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "stpMstRegionPol" {
  component = "stpMstRegionPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.stpMstRegionPol.content.name
    want        = module.main.name
  }

  equal "regName" {
    description = "regName"
    got         = data.aci_rest_managed.stpMstRegionPol.content.regName
    want        = "REG1"
  }

  equal "rev" {
    description = "rev"
    got         = data.aci_rest_managed.stpMstRegionPol.content.rev
    want        = "1"
  }
}

data "aci_rest_managed" "stpMstDomPol" {
  dn = "${data.aci_rest_managed.stpMstRegionPol.id}/mstpDomPol-INST1"

  depends_on = [module.main]
}

resource "test_assertions" "stpMstDomPol" {
  component = "stpMstDomPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.stpMstDomPol.content.name
    want        = "INST1"
  }

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.stpMstDomPol.content.id
    want        = "1"
  }
}

data "aci_rest_managed" "fvnsEncapBlk" {
  dn = "${data.aci_rest_managed.stpMstDomPol.id}/from-[vlan-10]-to-[vlan-20]"

  depends_on = [module.main]
}

resource "test_assertions" "fvnsEncapBlk" {
  component = "fvnsEncapBlk"

  equal "from" {
    description = "from"
    got         = data.aci_rest_managed.fvnsEncapBlk.content.from
    want        = "vlan-10"
  }

  equal "to" {
    description = "to"
    got         = data.aci_rest_managed.fvnsEncapBlk.content.to
    want        = "vlan-20"
  }

  equal "allocMode" {
    description = "allocMode"
    got         = data.aci_rest_managed.fvnsEncapBlk.content.allocMode
    want        = "inherit"
  }

  equal "role" {
    description = "role"
    got         = data.aci_rest_managed.fvnsEncapBlk.content.role
    want        = "external"
  }
}
