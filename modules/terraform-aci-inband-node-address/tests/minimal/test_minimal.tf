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

  node_id             = 201
  pod_id              = 2
  endpoint_group      = "INB1"
  endpoint_group_vlan = 104
}

data "aci_rest_managed" "mgmtRsInBStNode" {
  dn = "uni/tn-mgmt/mgmtp-default/inb-INB1/rsinBStNode-[topology/pod-2/node-201]"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsInBStNode" {
  component = "mgmtRsInBStNode"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.tDn
    want        = "topology/pod-2/node-201"
  }
}
