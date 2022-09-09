*** Settings ***
Documentation   Verify External Connectivity Policy Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
Verify External Connectivity Policy Faults
    ${r}=   GET On Session   apic   /api/mo/uni/tn-infra/fabricExtConnP-1/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "External Connectivity Policy has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "External Connectivity Policy has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "External Connectivity Policy has ${minor}[0] minor faults"
