*** Settings ***
Documentation   Atomic Counter
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Atomic Counter
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ogmode.json
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.adminSt   {{ apic.acess_policies.operations.atomic_counters.admin_state }}
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.mode   {{ apic.acess_policies.operations.atomic_counters.mode | default(defaults.apic.access_policies.operations.atomic_counters.mode) }}
