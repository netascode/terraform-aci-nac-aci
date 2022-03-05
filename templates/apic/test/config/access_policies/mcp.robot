*** Settings ***
Documentation   Verify MCP Global Instance
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify MCP Global Instance
    GET   "/api/mo/uni/infra/mcpInstP-default.json"
    String   $..mcpInstPol.attributes.adminSt   {{ apic.access_policies.mcp.admin_state | default(defaults.apic.access_policies.mcp.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   $..mcpInstPol.attributes.ctrl   {% if apic.access_policies.mcp.per_vlan | default(defaults.apic.access_policies.mcp.per_vlan) | cisco.aac.aac_bool("enabled") == "enabled" %}pdu-per-vlan{% elif apic.access_policies.mcp.per_vlan | default(defaults.apic.access_policies.mcp.per_vlan) | cisco.aac.aac_bool("enabled") == "disabled" %}""{% endif %}
    String   $..mcpInstPol.attributes.initDelayTime   {{ apic.access_policies.mcp.initial_delay | default(defaults.apic.access_policies.mcp.initial_delay) }}
    String   $..mcpInstPol.attributes.loopDetectMult   {{ apic.access_policies.mcp.loop_detection | default(defaults.apic.access_policies.mcp.loop_detection) }}
    String   $..mcpInstPol.attributes.loopProtectAct   {% if apic.access_policies.mcp.action | default(defaults.apic.access_policies.mcp.action) | cisco.aac.aac_bool("enabled") == "enabled" %}port-disable{% elif apic.access_policies.mcp.action | default(defaults.apic.access_policies.mcp.action) | cisco.aac.aac_bool("enabled") == "disabled" %}""{% endif %}
    String   $..mcpInstPol.attributes.txFreq   {{ apic.access_policies.mcp.frequency_sec | default(defaults.apic.access_policies.mcp.frequency_sec) }}
    String   $..mcpInstPol.attributes.txFreqMsec   {{ apic.access_policies.mcp.frequency_msec | default(defaults.apic.access_policies.mcp.frequency_msec) }}