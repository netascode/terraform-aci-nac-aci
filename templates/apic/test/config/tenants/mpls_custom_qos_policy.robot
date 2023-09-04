{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify MPLS Custom QoS Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for qos_policy in tenant.policies.mpls_custom_qos_policy | default([]) %}
{% set policy_name = qos_policy.name ~ defaults.apic.tenants.policies.mpls_custom_qos_policy.name_suffix %}

Verify MPLS Custom QoS Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qosmplscustom-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosmplscustom.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..qosmplscustom.attributes.descr   {{ qos_policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..qosmplscustom.attributes.nameAlias   {{ qos_policy.alias | default() }}

{% for ir in qos_policy.ingress_rules | default([]) %}
Verify MPLS Custom QoS Policy Ingress Rules {{ ir.exp_from }} - {{ ir.exp_to }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/exp-{{ ir.exp_from }}-{{ ir.exp_to }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsIngressRule.attributes.from   {{ ir.exp_from }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsIngressRule.attributes.to   {{ ir.exp_to }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsIngressRule.attributes.prio   {{ ir.priority | default(defaults.apic.tenants.policies.mpls_custom_qos_policy.ingress_rules.priority) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsIngressRule.attributes.target   {{ ir.dscp_target | default(defaults.apic.tenants.policies.mpls_custom_qos_policy.ingress_rules.dscp_target) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsIngressRule.attributes.targetCos   {{ ir.cos_target | default(defaults.apic.tenants.policies.mpls_custom_qos_policy.ingress_rules.cos_target) }}                    
{% endfor %}

{% for er in qos_policy.egress_rules | default([]) %}
Verify MPLS Custom QoS Egress Rules {{ er.dscp_from }} - {{ er.dscp_to }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/qoscustom-{{ policy_name }}/dscpToExp-{{ er.dscp_from }}-{{ er.dscp_to }}.json
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsEgressRule.attributes.from   {{ er.dscp_from }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsEgressRule.attributes.to   {{ er.dscp_to }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsEgressRule.attributes.targetExp   {{ er.exp_target | default(defaults.apic.tenants.policies.mpls_custom_qos_policy.egress_rules.exp_target) }}
    Should Be Equal Value Json String   ${r.json()}   $..qosMplsEgressRule.attributes.targetCos   {{ er.cos_target | default(defaults.apic.tenants.policies.mpls_custom_qos_policy.egress_rules.cos_target) }}                    
{% endfor %}

{% endfor %}
