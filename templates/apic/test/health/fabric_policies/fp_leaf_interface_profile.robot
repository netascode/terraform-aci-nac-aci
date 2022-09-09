*** Settings ***
Documentation   Verify Fabric Leaf Interface Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_interface_profile_name | default(defaults.apic.fabric_policies.leaf_interface_profile_name))) %}

Verify Leaf Interface Profile {{ leaf_interface_profile_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/leportp-{{ leaf_interface_profile_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_interface_profile_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_interface_profile_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ leaf_interface_profile_name }} has ${minor}[0] minor faults"

{% endif %}
{% endfor %}
