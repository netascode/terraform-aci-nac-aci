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

  name        = "TEST_FULL"
  description = "My Description"
  tenant      = aci_rest_managed.fvTenant.content.name
  entries = [
    {
      order     = 1
      action    = "deny"
      source_ip = "1.2.3.4/32"
      group_ip  = "224.0.0.0/8"
      rp_ip     = "3.4.5.6"
    },
    {
      order = 2
    }
  ]
}

data "aci_rest_managed" "pimRouteMapPol" {
  dn = "${aci_rest_managed.fvTenant.id}/rtmap-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "pimRouteMapPol" {
  component = "pimRouteMapPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pimRouteMapPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.pimRouteMapPol.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "pimRouteMapEntry_1" {
  dn = "${data.aci_rest_managed.pimRouteMapPol.id}/rtmapentry-1"

  depends_on = [module.main]
}

resource "test_assertions" "pimRouteMapEntry_1" {
  component = "pimRouteMapEntry_1"

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.pimRouteMapEntry_1.content.action
    want        = "deny"
  }

  equal "grp" {
    description = "grp"
    got         = data.aci_rest_managed.pimRouteMapEntry_1.content.grp
    want        = "224.0.0.0/8"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.pimRouteMapEntry_1.content.order
    want        = "1"
  }

  equal "rp" {
    description = "rp"
    got         = data.aci_rest_managed.pimRouteMapEntry_1.content.rp
    want        = "3.4.5.6"
  }

  equal "src" {
    description = "src"
    got         = data.aci_rest_managed.pimRouteMapEntry_1.content.src
    want        = "1.2.3.4/32"
  }
}

data "aci_rest_managed" "pimRouteMapEntry_2" {
  dn = "${data.aci_rest_managed.pimRouteMapPol.id}/rtmapentry-2"

  depends_on = [module.main]
}

resource "test_assertions" "pimRouteMapEntry_2" {
  component = "pimRouteMapEntry_2"

  equal "action" {
    description = "action"
    got         = data.aci_rest_managed.pimRouteMapEntry_2.content.action
    want        = "permit"
  }

  equal "grp" {
    description = "grp"
    got         = data.aci_rest_managed.pimRouteMapEntry_2.content.grp
    want        = "0.0.0.0"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.pimRouteMapEntry_2.content.order
    want        = "2"
  }

  equal "rp" {
    description = "rp"
    got         = data.aci_rest_managed.pimRouteMapEntry_2.content.rp
    want        = "0.0.0.0"
  }

  equal "src" {
    description = "src"
    got         = data.aci_rest_managed.pimRouteMapEntry_2.content.src
    want        = "0.0.0.0"
  }
}
