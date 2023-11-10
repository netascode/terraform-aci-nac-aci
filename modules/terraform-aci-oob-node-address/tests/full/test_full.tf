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
  pod_id         = 2
  ip             = "100.1.1.111/24"
  gateway        = "100.1.1.254"
  v6_ip          = "2001::2/64"
  v6_gateway     = "2001::1"
  endpoint_group = "OOB1"
}

data "aci_rest_managed" "mgmtRsOoBStNode" {
  dn = "uni/tn-mgmt/mgmtp-default/oob-OOB1/rsooBStNode-[topology/pod-2/node-111]"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsOoBStNode" {
  component = "mgmtRsOoBStNode"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.addr
    want        = "100.1.1.111/24"
  }

  equal "gw" {
    description = "gw"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.gw
    want        = "100.1.1.254"
  }

  equal "v6Addr" {
    description = "v6Addr"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.v6Addr
    want        = "2001::2/64"
  }

  equal "v6Gw" {
    description = "v6Gw"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.v6Gw
    want        = "2001::1"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.mgmtRsOoBStNode.content.tDn
    want        = "topology/pod-2/node-111"
  }
}
