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
  ip                  = "10.1.1.100/24"
  gateway             = "10.1.1.254"
  v6_ip               = "2002::2/64"
  v6_gateway          = "2002::1"
  endpoint_group      = "INB1"
  endpoint_group_vlan = 104
}

data "aci_rest_managed" "mgmtRsInBStNode" {
  dn = "uni/tn-mgmt/mgmtp-default/inb-INB1/rsinBStNode-[topology/pod-2/node-201]"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtRsInBStNode" {
  component = "mgmtRsInBStNode"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.addr
    want        = "10.1.1.100/24"
  }

  equal "gw" {
    description = "gw"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.gw
    want        = "10.1.1.254"
  }

  equal "v6Addr" {
    description = "v6Addr"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.v6Addr
    want        = "2002::2/64"
  }

  equal "v6Gw" {
    description = "v6Gw"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.v6Gw
    want        = "2002::1"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.mgmtRsInBStNode.content.tDn
    want        = "topology/pod-2/node-201"
  }
}
