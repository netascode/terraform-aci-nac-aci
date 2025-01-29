*** Settings ***
Documentation   Verify Atomic Counter
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Atomic Counter
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ogmode.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..dbgOngoingAcMode.attributes.name   {{ apic.acess_policies.operations.atomic_counters.name }}
