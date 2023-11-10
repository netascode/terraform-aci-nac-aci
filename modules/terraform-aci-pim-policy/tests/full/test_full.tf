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
  source                       = "../.."
  name                         = "FULL_POL"
  tenant                       = aci_rest_managed.fvTenant.content.name
  auth_type                    = "ah-md5"
  mcast_dom_boundary           = true
  passive                      = true
  strict_rfc                   = true
  designated_router_delay      = 6
  designated_router_priority   = 5
  hello_interval               = 10
  join_prune_interval          = 120
  neighbor_filter_policy       = "NEIGH_RM"
  join_prune_filter_policy_in  = "IN_RM"
  join_prune_filter_policy_out = "OUT_RM"
}

data "aci_rest_managed" "pimIfPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/pimifpol-FULL_POL"

  depends_on = [module.main]
}


resource "test_assertions" "pimIfPol" {
  component = "pimIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pimIfPol.content.name
    want        = "FULL_POL"
  }

  equal "authKey" {
    description = "authKey"
    got         = data.aci_rest_managed.pimIfPol.content.authKey
    want        = ""
  }

  equal "authT" {
    description = "authT"
    got         = data.aci_rest_managed.pimIfPol.content.authT
    want        = "ah-md5"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.pimIfPol.content.ctrl
    want        = "border,passive,strict-rfc-compliant"
  }

  equal "drDelay" {
    description = "drDelay"
    got         = data.aci_rest_managed.pimIfPol.content.drDelay
    want        = "6"
  }

  equal "drPrio" {
    description = "drPrio"
    got         = data.aci_rest_managed.pimIfPol.content.drPrio
    want        = "5"
  }

  equal "helloItvl" {
    description = "helloItvl"
    got         = data.aci_rest_managed.pimIfPol.content.helloItvl
    want        = "10"
  }

  equal "jpInterval" {
    description = "jpInterval"
    got         = data.aci_rest_managed.pimIfPol.content.jpInterval
    want        = "120"
  }

}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_neighbor_filter" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/pimifpol-FULL_POL/nbrfilter/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_neighbor_filter" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_neighbor_filter.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/rtmap-NEIGH_RM"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_join_prune_filter_out" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/pimifpol-FULL_POL/jpoutbfilter/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_join_prune_filter_out" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_join_prune_filter_out.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/rtmap-OUT_RM"
  }
}

data "aci_rest_managed" "rtdmcRsFilterToRtMapPol_join_prune_filter_in" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/pimifpol-FULL_POL/jpinbfilter/rsfilterToRtMapPol"

  depends_on = [module.main]
}

resource "test_assertions" "rtdmcRsFilterToRtMapPol_join_prune_filter_in" {
  component = "rtdmcRsFilterToRtMapPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.rtdmcRsFilterToRtMapPol_join_prune_filter_in.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/rtmap-IN_RM"
  }
}
