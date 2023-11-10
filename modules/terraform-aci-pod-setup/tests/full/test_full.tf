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

  pod_id   = 3
  tep_pool = "10.3.0.0/16"
  /* external_tep_pools = [
    {
      prefix                 = "172.16.18.0/24"
      reserved_address_count = 4
    },
    {
      prefix                 = "172.16.17.0/24"
      reserved_address_count = 2
    }
  ]
  remote_pools = [
    {
      id          = 1
      remote_pool = "10.191.200.0/24"
    },
    {
      id          = 2
      remote_pool = "10.191.202.0/24"
    }
  ] */
}

data "aci_rest_managed" "fabricSetupP" {
  dn = "uni/controller/setuppol/setupp-${module.main.id}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSetupP" {
  component = "fabricSetupP"

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.fabricSetupP.content.podId
    want        = "3"
  }

  equal "podType" {
    description = "podType"
    got         = data.aci_rest_managed.fabricSetupP.content.podType
    want        = "physical"
  }

  equal "tepPool" {
    description = "tepPool"
    got         = data.aci_rest_managed.fabricSetupP.content.tepPool
    want        = "10.3.0.0/16"
  }
}

/* data "aci_rest_managed" "fabricExtRoutablePodSubnet1" {
  dn = "uni/controller/setuppol/setupp-${module.main.id}/extrtpodsubnet-[172.16.18.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExtRoutablePodSubnet1" {
  component = "fabricExtRoutablePodSubnet1"

  equal "prefix" {
    description = "External TEP Pool prefix"
    got         = data.aci_rest_managed.fabricExtRoutablePodSubnet1.content.pool
    want        = "172.16.18.0/24"
  }

  equal "reserveAddressCount" {
    description = "Reserved Address count"
    got         = data.aci_rest_managed.fabricExtRoutablePodSubnet1.content.reserveAddressCount
    want        = "4"
  }
}

data "aci_rest_managed" "fabricExtRoutablePodSubnet2" {
  dn = "uni/controller/setuppol/setupp-${module.main.id}/extrtpodsubnet-[172.16.17.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExtRoutablePodSubnet2" {
  component = "fabricExtRoutablePodSubnet2"

  equal "prefix" {
    description = "External TEP Pool prefix"
    got         = data.aci_rest_managed.fabricExtRoutablePodSubnet2.content.pool
    want        = "172.16.17.0/24"
  }

  equal "reserveAddressCount" {
    description = "Reserved Address count"
    got         = data.aci_rest_managed.fabricExtRoutablePodSubnet2.content.reserveAddressCount
    want        = "2"
  }
}

data "aci_rest_managed" "fabricExtSetupP1" {
  dn = "uni/controller/setuppol/setupp-${module.main.id}/extsetupp-1"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExtSetupP1" {
  component = "fabricExtSetupP1"

  equal "extPoolId" {
    description = "Remote Pool ID"
    got         = data.aci_rest_managed.fabricExtSetupP1.content.extPoolId
    want        = "1"
  }

  equal "tepPool" {
    description = "Remote TEP Pool"
    got         = data.aci_rest_managed.fabricExtSetupP1.content.tepPool
    want        = "10.191.200.0/24"
  }
}

data "aci_rest_managed" "fabricExtSetupP2" {
  dn = "uni/controller/setuppol/setupp-${module.main.id}/extsetupp-2"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExtSetupP2" {
  component = "fabricExtSetupP2"

  equal "extPoolId" {
    description = "Remote Pool ID"
    got         = data.aci_rest_managed.fabricExtSetupP2.content.extPoolId
    want        = "2"
  }

  equal "tepPool" {
    description = "Remote TEP Pool"
    got         = data.aci_rest_managed.fabricExtSetupP2.content.tepPool
    want        = "10.191.202.0/24"
  }
} */
