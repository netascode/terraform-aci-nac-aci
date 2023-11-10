terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aci = {
      source  = "CiscoDevNet/aci"
      version = "= 2.10.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}

module "main" {
  source = "../.."

  model = {
    apic = {
      auto_generate_switch_pod_profiles = true
      access_policies = {
        vlan_pools = [
          {
            name = "VLAN_POOL_1"
          }
        ]
      }
      fabric_policies = {
        banners = {
          apic_cli_banner = "CLI Banner"
        }
      }
      pod_policies = {
        pods = [{
          id       = 13
          tep_pool = "148.126.0.0/16"
        }]
      }
      node_policies = {
        vpc_groups = {
          groups = [{
            name     = "GROUP_1451"
            id       = 451
            switch_1 = 1451
            switch_2 = 1452
          }]
        }
        nodes = [{
          id            = 1451
          name          = "LEAF1451"
          serial_number = "1234567"
          role          = "leaf"
        }]
      }
      interface_policies = {
        nodes = [{
          id = 1451
          fexes = [{
            id = 101
          }]
        }]
      }
      tenants = [{
        name = "TENANT1"
      }]
    }
  }

  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true
}

data "aci_rest_managed" "fvnsVlanInstP" {
  dn = "uni/infra/vlanns-[VLAN_POOL_1]-static"

  depends_on = [module.main]
}

resource "test_assertions" "fvnsVlanInstP" {
  component = "fvnsVlanInstP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvnsVlanInstP.content.name
    want        = "VLAN_POOL_1"
  }
}

data "aci_rest_managed" "aaaPreLoginBanner" {
  dn = "uni/userext/preloginbanner"

  depends_on = [module.main]
}

resource "test_assertions" "aaaPreLoginBanner" {
  component = "aaaPreLoginBanner"

  equal "message" {
    description = "message"
    got         = data.aci_rest_managed.aaaPreLoginBanner.content.message
    want        = "CLI Banner"
  }
}

data "aci_rest_managed" "fabricSetupP" {
  dn = "uni/controller/setuppol/setupp-13"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSetupP" {
  component = "fabricSetupP"

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.fabricSetupP.content.podId
    want        = "13"
  }

  equal "tepPool" {
    description = "tepPool"
    got         = data.aci_rest_managed.fabricSetupP.content.tepPool
    want        = "148.126.0.0/16"
  }
}

data "aci_rest_managed" "fabricExplicitGEp" {
  dn = "uni/fabric/protpol/expgep-GROUP_1451"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExplicitGEp" {
  component = "fabricExplicitGEp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricExplicitGEp.content.name
    want        = "GROUP_1451"
  }

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.fabricExplicitGEp.content.id
    want        = "451"
  }
}

data "aci_rest_managed" "infraFexP" {
  dn = "uni/infra/fexprof-LEAF1451-FEX101"

  depends_on = [module.main]
}

resource "test_assertions" "infraFexP" {
  component = "infraFexP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraFexP.content.name
    want        = "LEAF1451-FEX101"
  }
}

data "aci_rest_managed" "fvTenant" {
  dn = "uni/tn-TENANT1"

  depends_on = [module.main]
}

resource "test_assertions" "fvTenant" {
  component = "fvTenant"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvTenant.content.name
    want        = "TENANT1"
  }
}
