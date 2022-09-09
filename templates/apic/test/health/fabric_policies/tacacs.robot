*** Settings ***
Documentation   Verify TACACS Provider Health
Suite Setup     Login APIC
Default Tags    apic   day0   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for prov in apic.fabric_policies.aaa.tacacs_providers | default([]) %}

Verify TACACS Provider {{ prov.hostname_ip }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/userext/tacacsext/tacacsplusprovider-{{ prov.hostname_ip }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ prov.hostname_ip }} has ${minor}[0] minor faults"

{% endfor %}
