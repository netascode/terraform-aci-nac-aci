*** Settings ***
Documentation   Verify Fabric Spine Interface Profile
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) | cisco.aac.aac_bool("enabled") == "enabled" or apic.auto_generate_fabric_spine_switch_interface_profiles | default(defaults.apic.auto_generate_fabric_spine_switch_interface_profiles) | cisco.aac.aac_bool("enabled") == "enabled" %}
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "spine" %}
{% set spine_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.spine_interface_profile_name | default(defaults.apic.fabric_policies.spine_interface_profile_name))) %}

Verify Fabric Spine Interface Profile {{ spine_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/spportp-{{ spine_interface_profile_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricSpPortP.attributes.name   {{ spine_interface_profile_name }}

{% endif %}
{% endfor %}
{% endif %}

{% for prof in apic.fabric_policies.spine_interface_profiles | default([]) %}
{% set spine_interface_profile_name = prof.name ~ defaults.apic.fabric_policies.spine_interface_profiles.name_suffix %}

Verify Fabric Spine Interface Profile {{ spine_interface_profile_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/spportp-{{ spine_interface_profile_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricSpPortP.attributes.name   {{ spine_interface_profile_name }}

{% endfor %}
