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

  node_id = 101
  port    = 1
  type    = "downlink"
}

data "aci_rest_managed" "infraRsPortDirection" {
  dn = "uni/infra/prtdirec/rsportDirection-[topology/pod-1/paths-101/pathep-[eth1/1]]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsPortDirection" {
  component = "infraRsPortDirection"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsPortDirection.content.tDn
    want        = "topology/pod-1/paths-101/pathep-[eth1/1]"
  }

  equal "direc" {
    description = "direc"
    got         = data.aci_rest_managed.infraRsPortDirection.content.direc
    want        = "DownLink"
  }

}
