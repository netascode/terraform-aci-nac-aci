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

  node_id        = 111
  endpoint_group = "OOB1"
}

data "aci_rest_managed" "mgmtRsOoBStNode" {
  dn = "uni/tn-mgmt/mgmtp-default/oob-OOB1/rsooBStNode-[topology/pod-1/node-111]"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsOoBStNode" {
  component = "mgmtRsOoBStNode"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.tDn
    want        = "topology/pod-1/node-111"
  }
}
