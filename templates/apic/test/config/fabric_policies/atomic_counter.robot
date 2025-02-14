*** Settings ***
Documentation   Verify Atomic Counter
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Atomic Counter
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ogmode.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.adminSt   {{ 'enabled' if apic.fabric_policies.atomic_counters.admin_state | default(defaults.apic.fabric_policies.atomic_counters.admin_state) else 'disabled' }}
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.mode   {{ apic.fabric_policies.atomic_counter.mode }}

