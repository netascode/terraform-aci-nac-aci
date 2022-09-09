*** Settings ***
Documentation   Verify Pod Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   pod_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pod in apic.pod_policies.pods | default([]) %}

Verify Pod {{ pod.id }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/controller/setuppol/setupp-{{ pod.id }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod.id }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod.id }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod.id }} has ${minor}[0] minor faults"

{% endfor %}
