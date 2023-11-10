terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.0"
    }
  }
}

module "main" {
  source = "../.."

  node_id     = 101
  breakout    = "10g-4x"
  description = "Port breakout"
  port        = 11
}

data "aci_rest_managed" "infraPortConfig" {
  dn         = "uni/infra/portconfnode-101-card-1-port-11-sub-0"
  depends_on = [module.main]
}

resource "test_assertions" "infraPortConfig" {
  component = "infraPortConfig"

  equal "assocGrp" {
    description = "Policy Group"
    got         = data.aci_rest_managed.infraPortConfig.content.assocGrp
    want        = ""
  }

  equal "port" {
    description = "Port"
    got         = data.aci_rest_managed.infraPortConfig.content.port
    want        = "11"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraPortConfig.content.description
    want        = "Port breakout"
  }

  equal "node" {
    description = "Node ID"
    got         = data.aci_rest_managed.infraPortConfig.content.node
    want        = "101"
  }

  equal "brkoutMap" {
    description = "Breakout Map"
    got         = data.aci_rest_managed.infraPortConfig.content.brkoutMap
    want        = "10g-4x"
  }

  equal "role" {
    description = "Node role"
    got         = data.aci_rest_managed.infraPortConfig.content.role
    want        = "leaf"
  }

  equal "subPort" {
    description = "Subport"
    got         = data.aci_rest_managed.infraPortConfig.content.subPort
    want        = "0"
  }

  equal "connectedFex" {
    description = "Connected FEX"
    got         = data.aci_rest_managed.infraPortConfig.content.connectedFex
    want        = "unspecified"
  }
}
