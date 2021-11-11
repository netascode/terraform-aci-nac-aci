*** Settings ***
Documentation   Verify Fabric Leaf Switch Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pod in apic.pod_policies.pods | default([]) %}
{% set pod_profile_name = (pod.id) | regex_replace("^(?P<id>.+)$", (apic.fabric_policies.pod_profile_name | default(defaults.apic.fabric_policies.pod_profile_name))) %}

Verify Pod Profile {{ pod_profile_name }} Faults
    GET   "/api/mo/uni/fabric/podprof-{{ pod_profile_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod_profile_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod_profile_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pod_profile_name }} has ${minor} minor faults"

{% endfor %}
