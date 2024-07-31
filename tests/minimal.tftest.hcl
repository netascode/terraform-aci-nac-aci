variables {
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
        global_settings = {
          reallocate_gipo = true
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

run "execute" {
  command = apply
}

run "verify" {
  module {
    source = "./tests/minimal"
  }

  assert {
    condition     = data.aci_rest_managed.fvnsVlanInstP.content.name == "VLAN_POOL_1"
    error_message = "Correct vlan pool not present"
  }

  assert {
    condition     = data.aci_rest_managed.aaaPreLoginBanner.content.message == "CLI Banner"
    error_message = "Correct cli banner not present"
  }

  assert {
    condition     = data.aci_rest_managed.fabricSetupP.content.podId == "13"
    error_message = "Correct pod id not present"
  }

  assert {
    condition     = data.aci_rest_managed.fabricSetupP.content.tepPool == "148.126.0.0/16"
    error_message = "Correct tep pool not present"
  }

  assert {
    condition     = data.aci_rest_managed.fabricExplicitGEp.content.name == "GROUP_1451"
    error_message = "Correct vpc group not present"
  }

  assert {
    condition     = data.aci_rest_managed.fabricExplicitGEp.content.id == "451"
    error_message = "Correct vpc id not present"
  }

  assert {
    condition     = data.aci_rest_managed.infraFexP.content.name == "LEAF1451-FEX101"
    error_message = "Correct fex profile not present"
  }

  assert {
    condition     = data.aci_rest_managed.fvTenant.content.name == "TENANT1"
    error_message = "Correct tenant not present"
  }
}
