*** Settings ***
Documentation   Verify FEX Interface Profile Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   access_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.interface_policies.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node.id ~ "`]" %}
{% set full_node = (apic.node_policies | json_query(query))[0] %}
{% if full_node.role == "leaf" %}
{% for fex in node.fexes | default([]) %}
{% set fex_profile_name = (full_node.id ~ ":" ~ full_node.name~ ":" ~ fex.id) | regex_replace("^(?P<id>.+):(?P<name>.+):(?P<fex>.+)$", (apic.access_policies.fex_profile_name | default(defaults.apic.access_policies.fex_profile_name))) %}

Verify FEX Interface Profile {{ fex_profile_name }} Faults
    GET   "/api/mo/uni/infra/fexprof-{{ fex_profile_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ fex_profile_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ fex_profile_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ fex_profile_name }} has ${minor} minor faults"

{% endfor %}
{% endif %}
{% endfor %}
