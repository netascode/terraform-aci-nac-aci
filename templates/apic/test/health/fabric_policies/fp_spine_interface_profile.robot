*** Settings ***
Documentation   Verify Fabric Spine Interface Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.spine_interface_profile_name | default(defaults.apic.fabric_policies.spine_interface_profile_name))) %}

Verify Spine Interface Profile {{ spine_interface_profile_name }} Faults
    GET   "/api/mo/uni/fabric/spportp-{{ spine_interface_profile_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_interface_profile_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_interface_profile_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ spine_interface_profile_name }} has ${minor} minor faults"

{% endif %}
{% endfor %}
