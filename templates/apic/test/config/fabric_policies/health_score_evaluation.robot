*** Settings ***
Documentation   Health Score Evaluation
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Healt Score Acknowledged Faults
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/hsPols/hseval.json
    Should Be Equal Value Json String   ${r.json()}    $..healthEvalP.attributes.ignoreAckedFaults   {{ apic.fabric_policies.ignore_acked_faults | default(defaults.apic.fabric_policies.ignore_acked_faults) | cisco.aac.aac_bool("yes") }}
