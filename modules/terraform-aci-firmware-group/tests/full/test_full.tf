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

  name     = "UG1"
  node_ids = [101]
}

data "aci_rest_managed" "firmwareFwGrp" {
  dn = "uni/fabric/fwgrp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "firmwareFwGrp" {
  component = "firmwareFwGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.firmwareFwGrp.content.name
    want        = module.main.name
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.firmwareFwGrp.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "firmwareFwP" {
  dn = "uni/fabric/fwpol-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "firmwareFwP" {
  component = "firmwareFwP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.firmwareFwP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "firmwareRsFwgrpp" {
  dn = "${data.aci_rest_managed.firmwareFwGrp.id}/rsfwgrpp"

  depends_on = [module.main]
}

resource "test_assertions" "firmwareRsFwgrpp" {
  component = "firmwareRsFwgrpp"

  equal "tnFirmwareFwPName" {
    description = "tnFirmwareFwPName"
    got         = data.aci_rest_managed.firmwareRsFwgrpp.content.tnFirmwareFwPName
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricNodeBlk" {
  dn = "${data.aci_rest_managed.firmwareFwGrp.id}/nodeblk-101"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodeBlk" {
  component = "fabricNodeBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricNodeBlk.content.name
    want        = "101"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest_managed.fabricNodeBlk.content.from_
    want        = "101"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest_managed.fabricNodeBlk.content.to_
    want        = "101"
  }
}
