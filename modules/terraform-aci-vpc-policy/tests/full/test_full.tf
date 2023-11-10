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

  name               = "VPC1"
  peer_dead_interval = 300
}

data "aci_rest_managed" "vpcInstPol" {
  dn = "uni/fabric/vpcInst-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vpcInstPol" {
  component = "vpcInstPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vpcInstPol.content.name
    want        = module.main.name
  }

  equal "deadIntvl" {
    description = "deadIntvl"
    got         = data.aci_rest_managed.vpcInstPol.content.deadIntvl
    want        = "300"
  }
}
