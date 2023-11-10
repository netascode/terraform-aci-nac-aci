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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "DHCP-RELAY1"
  description = "My Description"
  providers_ = [
    {
      ip                  = "10.1.1.1"
      type                = "epg"
      tenant              = "ABC"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
    },
    {
      ip                      = "10.1.10.1"
      type                    = "external_epg"
      tenant                  = "ABC"
      l3out                   = "L3OUT1"
      external_endpoint_group = "EXT-EPG1"
    }
  ]
}

data "aci_rest_managed" "dhcpRelayP" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "dhcpRelayP" {
  component = "dhcpRelayP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.dhcpRelayP.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.dhcpRelayP.content.descr
    want        = "My Description"
  }


  equal "owner" {
    description = "owner"
    got         = data.aci_rest_managed.dhcpRelayP.content.owner
    want        = "tenant"
  }
}

data "aci_rest_managed" "dhcpRsProv_1" {
  dn = "${data.aci_rest_managed.dhcpRelayP.id}/rsprov-[uni/tn-ABC/ap-AP1/epg-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpRsProv_1" {
  component = "dhcpRsProv_1"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.dhcpRsProv_1.content.tDn
    want        = "uni/tn-ABC/ap-AP1/epg-EPG1"
  }

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.dhcpRsProv_1.content.addr
    want        = "10.1.1.1"
  }
}

data "aci_rest_managed" "dhcpRsProv_2" {
  dn = "${data.aci_rest_managed.dhcpRelayP.id}/rsprov-[uni/tn-ABC/out-L3OUT1/instP-EXT-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpRsProv_2" {
  component = "dhcpRsProv_2"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.dhcpRsProv_2.content.tDn
    want        = "uni/tn-ABC/out-L3OUT1/instP-EXT-EPG1"
  }

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.dhcpRsProv_2.content.addr
    want        = "10.1.10.1"
  }
}
