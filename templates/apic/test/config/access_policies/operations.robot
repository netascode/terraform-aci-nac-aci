*** Settings ***
Documentation   Atomic Counter
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Atomic Counter
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ogmode.json
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.adminSt   {{ apic.fabric_policies.operations.atomic_counter.admin_state | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.mode   {{ apic.fabric_policies.operations.atomic_counter.mode | default(defaults.apic.fabric_policies.operations.atomic_counter.mode }}
