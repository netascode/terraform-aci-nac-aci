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

  name                       = "TEST_FULL"
  tenant                     = aci_rest_managed.fvTenant.content.name
  description                = "My IGMP Snooping Policy"
  admin_state                = false
  fast_leave                 = true
  querier                    = true
  last_member_query_interval = 10
  query_interval             = 100
  query_response_interval    = 10
  start_query_count          = 10
  start_query_interval       = 10
}

data "aci_rest_managed" "igmpSnoopPol" {
  dn = "${aci_rest_managed.fvTenant.id}/snPol-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "igmpSnoopPol" {
  component = "igmpSnoopPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.igmpSnoopPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.igmpSnoopPol.content.descr
    want        = "My IGMP Snooping Policy"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.igmpSnoopPol.content.adminSt
    want        = "disabled"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.ctrl
    want        = "fast-leave,querier"
  }

  equal "lastMbrIntvl" {
    description = "lastMbrIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.lastMbrIntvl
    want        = "10"
  }

  equal "queryIntvl" {
    description = "queryIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.queryIntvl
    want        = "100"
  }

  equal "rspIntvl" {
    description = "rspIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.rspIntvl
    want        = "10"
  }

  equal "startQueryCnt" {
    description = "startQueryCnt"
    got         = data.aci_rest_managed.igmpSnoopPol.content.startQueryCnt
    want        = "10"
  }

  equal "startQueryIntvl" {
    description = "startQueryIntvl"
    got         = data.aci_rest_managed.igmpSnoopPol.content.startQueryIntvl
    want        = "10"
  }
}
