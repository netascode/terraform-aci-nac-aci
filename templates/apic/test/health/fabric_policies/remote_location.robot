*** Settings ***
Documentation   Verify Remote Location Health
Suite Setup     Login APIC
Default Tags    apic   day0   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for rl in apic.fabric_policies.remote_locations | default([]) %}
{% set rl_name = rl.name ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}

Verify Remote Location {{ rl_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/path-{{ rl_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ rl_name }} has ${minor}[0] minor faults"

{% endfor %}
