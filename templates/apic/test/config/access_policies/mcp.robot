*** Settings ***
Documentation   Verify MCP Global Instance
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify MCP Global Instance
    ${r}=   GET On Session   apic   /api/mo/uni/infra/mcpInstP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.adminSt   {{ apic.access_policies.mcp.admin_state | default(defaults.apic.access_policies.mcp.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.ctrl   {% if apic.access_policies.mcp.per_vlan | default(defaults.apic.access_policies.mcp.per_vlan) | cisco.aac.aac_bool("enabled") == "enabled" %}pdu-per-vlan{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.initDelayTime   {{ apic.access_policies.mcp.initial_delay | default(defaults.apic.access_policies.mcp.initial_delay) }}
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.loopDetectMult   {{ apic.access_policies.mcp.loop_detection | default(defaults.apic.access_policies.mcp.loop_detection) }}
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.loopProtectAct   {% if apic.access_policies.mcp.action | default(defaults.apic.access_policies.mcp.action) | cisco.aac.aac_bool("enabled") == "enabled" %}port-disable{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.txFreq   {{ apic.access_policies.mcp.frequency_sec | default(defaults.apic.access_policies.mcp.frequency_sec) }}
    Should Be Equal Value Json String   ${r.json()}    $..mcpInstPol.attributes.txFreqMsec   {{ apic.access_policies.mcp.frequency_msec | default(defaults.apic.access_policies.mcp.frequency_msec) }}