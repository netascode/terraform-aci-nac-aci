*** Settings ***
Documentation   Verify Error Disabled Recovery Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Error Disabled Recovery Policy
    GET   "/api/mo/uni/infra/edrErrDisRecoverPol-default.json?rsp-subtree=full"
    String   $..edrErrDisRecoverPol.attributes.errDisRecovIntvl   {{ apic.fabric_policies.err_disabled_recovery.interval | default(defaults.apic.fabric_policies.err_disabled_recovery.interval) }}

Verify MCP Loop Policy
    ${policy}=   Set Variable   $..edrErrDisRecoverPol.children[?(@.edrEventP.attributes.event=='event-mcp-loop')]
    String   ${policy}..edrEventP.attributes.recover   {{ apic.fabric_policies.err_disabled_recovery.mcp_loop | default(defaults.apic.fabric_policies.err_disabled_recovery.mcp_loop) }}

Verify EP Move Policy
    ${policy}=   Set Variable   $..edrErrDisRecoverPol.children[?(@.edrEventP.attributes.event=='event-ep-move')]
    String   ${policy}..edrEventP.attributes.recover   {{ apic.fabric_policies.err_disabled_recovery.ep_move | default(defaults.apic.fabric_policies.err_disabled_recovery.ep_move) }}

Verify BPDU Guard Policy
    ${policy}=   Set Variable   $..edrErrDisRecoverPol.children[?(@.edrEventP.attributes.event=='event-bpduguard')]
    String   ${policy}..edrEventP.attributes.recover   {{ apic.fabric_policies.err_disabled_recovery.bpdu_guard | default(defaults.apic.fabric_policies.err_disabled_recovery.bpdu_guard) }}
