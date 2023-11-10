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

  node_id      = 101
  policy_group = "ACC1"
  description  = "Port description"
  port         = 10
}

data "aci_rest_managed" "infraPortConfig" {
  dn         = "uni/infra/portconfnode-101-card-1-port-10-sub-0"
  depends_on = [module.main]
}

resource "test_assertions" "infraPortConfig" {
  component = "infraPortConfig"

  equal "assocGrp" {
    description = "Policy Group"
    got         = data.aci_rest_managed.infraPortConfig.content.assocGrp
    want        = "uni/infra/funcprof/accportgrp-ACC1"
  }

  equal "port" {
    description = "Port"
    got         = data.aci_rest_managed.infraPortConfig.content.port
    want        = "10"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraPortConfig.content.description
    want        = "Port description"
  }

  equal "node" {
    description = "Node ID"
    got         = data.aci_rest_managed.infraPortConfig.content.node
    want        = "101"
  }
}
