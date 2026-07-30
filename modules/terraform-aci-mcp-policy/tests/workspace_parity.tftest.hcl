mock_provider "aci" {}

# Mirrors /Users/suhkb/git/terraform/workspace/mcp-per-vlan/yaml/mcp.nac.yaml.
# Sub-values that the top-level resolves from defaults are passed explicitly here.

run "mcp_default" { # name + admin_state only -> legacy safe, nothing extra
  command = plan
  variables {
    name        = "MCP-DEFAULT"
    admin_state = true
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["adminSt"] == "enabled" && !can(aci_rest_managed.mcpIfPol.content["mcpPduPerVlan"]) && !can(aci_rest_managed.mcpIfPol.content["mcpMode"])
    error_message = "legacy policy must emit only name+adminSt"
  }
}

run "mcp_disabled" {
  command = plan
  variables {
    name        = "MCP-DISABLED"
    admin_state = false
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["adminSt"] == "disabled" && !can(aci_rest_managed.mcpIfPol.content["mcpMode"])
    error_message = "disabled policy must emit adminSt=disabled, no strict attrs"
  }
}

run "mcp_per_vlan" {
  command = plan
  variables {
    name         = "MCP-PER-VLAN"
    admin_state  = true
    per_vlan_mcp = true
    max_vlans    = 254
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["mcpPduPerVlan"] == "on" && aci_rest_managed.mcpIfPol.content["maxPduPerVlanLimit"] == "254" && !can(aci_rest_managed.mcpIfPol.content["mcpMode"])
    error_message = "per_vlan true -> mcpPduPerVlan=on + maxPduPerVlanLimit, no mcpMode"
  }
}

run "mcp_per_vlan_off" {
  command = plan
  variables {
    name         = "MCP-PERVLAN-OFF"
    admin_state  = true
    per_vlan_mcp = false
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["mcpPduPerVlan"] == "off" && !can(aci_rest_managed.mcpIfPol.content["maxPduPerVlanLimit"]) && !can(aci_rest_managed.mcpIfPol.content["mcpMode"])
    error_message = "per_vlan false -> mcpPduPerVlan=off, NO maxPduPerVlanLimit, no mcpMode"
  }
}

run "mcp_strict_off" {
  command = plan
  variables {
    name        = "MCP-STRICT-OFF"
    admin_state = true
    strict_mode = false
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["mcpMode"] == "off" && !can(aci_rest_managed.mcpIfPol.content["gracePeriod"]) && !can(aci_rest_managed.mcpIfPol.content["mcpPduPerVlan"])
    error_message = "strict false -> mcpMode=off, no timers, no per-vlan"
  }
}

run "mcp_strict_defaults" { # strict_mode true; timers resolve from defaults at top-level
  command = plan
  variables {
    name              = "MCP-STRICT-DEFAULTS"
    admin_state       = true
    strict_mode       = true
    grace_period      = 3
    grace_period_msec = 0
    initial_delay     = 0
    frequency_sec     = 0
    frequency_msec    = 500
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["mcpMode"] == "on" && aci_rest_managed.mcpIfPol.content["gracePeriod"] == "3" && aci_rest_managed.mcpIfPol.content["strictTxFreqMsec"] == "500"
    error_message = "strict true w/ defaults -> mcpMode=on + timers from defaults"
  }
}

run "mcp_strict_full" {
  command = plan
  variables {
    name              = "MCP-STRICT"
    admin_state       = true
    per_vlan_mcp      = true
    max_vlans         = 128
    strict_mode       = true
    grace_period      = 5
    grace_period_msec = 500
    initial_delay     = 180
    frequency_sec     = 2
    frequency_msec    = 250
  }
  assert {
    condition     = aci_rest_managed.mcpIfPol.content["mcpPduPerVlan"] == "on" && aci_rest_managed.mcpIfPol.content["maxPduPerVlanLimit"] == "128" && aci_rest_managed.mcpIfPol.content["mcpMode"] == "on" && aci_rest_managed.mcpIfPol.content["gracePeriod"] == "5" && aci_rest_managed.mcpIfPol.content["gracePeriodMsec"] == "500" && aci_rest_managed.mcpIfPol.content["strictInitDelayTime"] == "180" && aci_rest_managed.mcpIfPol.content["strictTxFreq"] == "2" && aci_rest_managed.mcpIfPol.content["strictTxFreqMsec"] == "250"
    error_message = "strict full -> per-vlan + mcpMode=on + all 5 timers"
  }
}
