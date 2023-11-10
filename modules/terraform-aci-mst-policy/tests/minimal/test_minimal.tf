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
