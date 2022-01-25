*** Settings ***
Documentation   Verify QoS Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for qos_policy in tenant.policies.qos | default([]) %}
{% set policy_name = qos_policy.name ~ defaults.apic.tenants.policies.qos_policies.name_suffix %}

Verify QoS Policy {{ policy_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}.json"
    String   $..qosCustomPol.attributes.name   {{ policy_name }}
    String   $..qosCustomPol.attributes.descr   {{ qos_policy.description | default() }}
    String   $..qosCustomPol.attributes.nameAlias   {{ qos_policy.alias | default() }}

{% for pm in qos_policy.dscp_priority_maps | default([]) %}
Verify QoS Policy DSCP Priority Map {{ pm.dscp_from }} - {{ pm.dscp_to }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/dcsp-{{ pm.dscp_from }}-{{ pm.dscp_to }}.json"
    String   $..qosDscpClass.attributes.from   {{ pm.dscp_from }}
    String   $..qosDscpClass.attributes.to   {{ pm.dscp_to }}
    String   $..qosDscpClass.attributes.prio   {{ pm.priority | default(defaults.apic.tenants.policies.qos_policies.dscp_priority_maps.priority) }}
    String   $..qosDscpClass.attributes.target   {{ pm.dscp_target | default(defaults.apic.tenants.policies.qos_policies.dscp_priority_maps.dscp_target) }}
    String   $..qosDscpClass.attributes.targetCos   {{ pm.cos_target | default(defaults.apic.tenants.policies.qos_policies.dscp_priority_maps.cos_target) }}                    
{% endfor %}

{% for d1p in qos_policy.dot1p_classifiers | default([]) %}
Verify QoS Dot1P Classifier {{ d1p.dot1p_from }} - {{ d1p.dot1p_to }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/dot1P-{{ d1p.dot1p_from }}-{{ d1p.dot1p_to }}.json"
    String   $..qosDot1PClass.attributes.from   {{ d1p.dot1p_from }}
    String   $..qosDot1PClass.attributes.to   {{ d1p.dot1p_to }}
    String   $..qosDot1PClass.attributes.prio   {{ d1p.priority | default(defaults.apic.tenants.policies.qos_policies.dot1p_classifiers.priority) }}
    String   $..qosDot1PClass.attributes.target   {{ d1p.dscp_target | default(defaults.apic.tenants.policies.qos_policies.dot1p_classifiers.dscp_target) }}
    String   $..qosDot1PClass.attributes.targetCos   {{ d1p.cos_target | default(defaults.apic.tenants.policies.qos_policies.dot1p_classifiers.cos_target) }}                    
{% endfor %}

{% endfor %}
