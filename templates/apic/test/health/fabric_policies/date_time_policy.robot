*** Settings ***
Documentation   Verify Date Time Policy Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.pod_policies.date_time_policies | default([]) %}
{% set date_time_policy_name = policy.name ~ defaults.apic.fabric_policies.pod_policies.date_time_policies.name_suffix %}

Verify Date Time Policy {{ date_time_policy_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/time-{{ date_time_policy_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ date_time_policy_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ date_time_policy_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ date_time_policy_name }} has ${minor}[0] minor faults"

{% endfor %}
