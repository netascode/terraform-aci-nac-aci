*** Settings ***
Documentation   Health Score Evaluation
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Healt Score Acknowledged Faults
    GET   "/api/mo/uni/fabric/hsPols/hseval.json"
    String   $..healthEvalP.attributes.ignoreAckedFaults   {{ apic.fabric_policies.ignore_acked_faults | default(defaults.apic.fabric_policies.ignore_acked_faults) | cisco.aac.aac_bool("yes") }}
