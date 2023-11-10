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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant         = aci_rest_managed.fvTenant.content.name
  name           = "TEST_FULL"
  description    = "My Description"
  dhcp_v4_server = true
  dhcp_v6_server = true
  ipv6_router    = true
  arp            = true
  nd             = true
  ra             = true
}

data "aci_rest_managed" "fhsTrustCtrlPol" {
  dn = "uni/tn-TF/trustctrlpol-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "fhsTrustCtrlPol" {
  component = "fhsTrustCtrlPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.descr
    want        = "My Description"
  }

  equal "hasDhcpv4Server" {
    description = "hasDhcpv4Server"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.hasDhcpv4Server
    want        = "yes"
  }

  equal "hasDhcpv6Server" {
    description = "hasDhcpv6Server"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.hasDhcpv6Server
    want        = "yes"
  }

  equal "hasIpv6Router" {
    description = "hasIpv6Router"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.hasIpv6Router
    want        = "yes"
  }

  equal "trustArp" {
    description = "trustArp"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.trustArp
    want        = "yes"
  }

  equal "trustNd" {
    description = "trustNd"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.trustNd
    want        = "yes"
  }

  equal "trustRa" {
    description = "trustRa"
    got         = data.aci_rest_managed.fhsTrustCtrlPol.content.trustRa
    want        = "yes"
  }
}
