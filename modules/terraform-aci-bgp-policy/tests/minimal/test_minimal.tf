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
