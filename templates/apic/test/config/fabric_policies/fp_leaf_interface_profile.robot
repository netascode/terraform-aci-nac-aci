*** Settings ***
Documentation   Verify Fabrc Leaf Interface Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_fabric_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_fabric_leaf_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_interface_profile_name | default(defaults.apic.fabric_policies.leaf_interface_profile_name))) %}

Verify Fabric Leaf Interface Profile {{ leaf_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/leportp-{{ leaf_interface_profile_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricLePortP.attributes.name   {{ leaf_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.fabric_policies.leaf_interface_profiles | default([]) %}
{% set leaf_interface_profile_name = prof.name ~ defaults.apic.fabric_policies.leaf_interface_profiles.name_suffix %}

Verify Fabric Leaf Interface Profile {{ leaf_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/leportp-{{ leaf_interface_profile_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricLePortP.attributes.name   {{ leaf_interface_profile_name }}

{% endfor %}
