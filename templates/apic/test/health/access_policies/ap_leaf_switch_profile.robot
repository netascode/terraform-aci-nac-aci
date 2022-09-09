*** Settings ***
Documentation   Verify Access Leaf Switch Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   access_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_profile_name | default(defaults.apic.access_policies.leaf_switch_profile_name))) %}

Verify Leaf Switch Profile {{ leaf_switch_profile_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/infra/nprof-{{ leaf_switch_profile_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_switch_profile_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_switch_profile_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_switch_profile_name }} has ${minor}[0] minor faults"

{% endif %}
{% endfor %}
