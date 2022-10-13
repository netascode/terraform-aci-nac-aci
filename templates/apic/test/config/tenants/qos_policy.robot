{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify QoS Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for qos_policy in tenant.policies.qos | default([]) %}
{% set policy_name = qos_policy.name ~ defaults.apic.tenants.policies.qos.name_suffix %}

Verify QoS Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosCustomPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..qosCustomPol.attributes.descr   {{ qos_policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..qosCustomPol.attributes.nameAlias   {{ qos_policy.alias | default() }}

{% for pm in qos_policy.dscp_priority_maps | default([]) %}
Verify QoS Policy DSCP Priority Map {{ pm.dscp_from }} - {{ pm.dscp_to }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/dcsp-{{ pm.dscp_from }}-{{ pm.dscp_to }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosDscpClass.attributes.from   {{ pm.dscp_from }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDscpClass.attributes.to   {{ pm.dscp_to }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDscpClass.attributes.prio   {{ pm.priority | default(defaults.apic.tenants.policies.qos.dscp_priority_maps.priority) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDscpClass.attributes.target   {{ pm.dscp_target | default(defaults.apic.tenants.policies.qos.dscp_priority_maps.dscp_target) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDscpClass.attributes.targetCos   {{ pm.cos_target | default(defaults.apic.tenants.policies.qos.dscp_priority_maps.cos_target) }}                    
{% endfor %}

{% for d1p in qos_policy.dot1p_classifiers | default([]) %}
Verify QoS Dot1P Classifier {{ d1p.dot1p_from }} - {{ d1p.dot1p_to }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/dot1P-{{ d1p.dot1p_from }}-{{ d1p.dot1p_to }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosDot1PClass.attributes.from   {{ d1p.dot1p_from }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDot1PClass.attributes.to   {{ d1p.dot1p_to }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDot1PClass.attributes.prio   {{ d1p.priority | default(defaults.apic.tenants.policies.qos.dot1p_classifiers.priority) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDot1PClass.attributes.target   {{ d1p.dscp_target | default(defaults.apic.tenants.policies.qos.dot1p_classifiers.dscp_target) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosDot1PClass.attributes.targetCos   {{ d1p.cos_target | default(defaults.apic.tenants.policies.qos.dot1p_classifiers.cos_target) }}                    
{% endfor %}

{% endfor %}
