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

  fabric_bgp_as = 65000
  fabric_bgp_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
  fabric_bgp_external_rr = [{
    node_id = 2001
    pod_id  = 2
  }]
}

data "aci_rest_managed" "bgpAsP" {
  dn = "uni/fabric/bgpInstP-default/as"

  depends_on = [module.main]
}

resource "test_assertions" "bgpAsP" {
  component = "bgpAsP"

  equal "asn" {
    description = "asn"
    got         = data.aci_rest_managed.bgpAsP.content.asn
    want        = "65000"
  }
}

data "aci_rest_managed" "bgpRRNodePEp" {
  dn = "uni/fabric/bgpInstP-default/rr/node-2001"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRRNodePEp" {
  component = "bgpRRNodePEp"

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.bgpRRNodePEp.content.id
    want        = "2001"
  }

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.bgpRRNodePEp.content.podId
    want        = "2"
  }
}

data "aci_rest_managed" "bgpRRNodePEp-Ext" {
  dn = "uni/fabric/bgpInstP-default/extrr/node-2001"

  depends_on = [module.main]
}

resource "test_assertions" "bgpRRNodePEp-Ext" {
  component = "bgpRRNodePEp-Ext"

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.bgpRRNodePEp-Ext.content.id
    want        = "2001"
  }

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.bgpRRNodePEp-Ext.content.podId
    want        = "2"
  }
}
