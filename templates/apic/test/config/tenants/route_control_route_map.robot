{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Route Control Route Map
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for route_map in tenant.policies.route_control_route_maps | default([]) %}
{% set route_map_name = route_map.name ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix %}

Verify Route Map {{ route_map_name }} for Route Control
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/prof-{{ route_map_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlProfile.attributes.name   {{ route_map_name }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlProfile.attributes.descr   {{ route_map.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlProfile.attributes.type   combinable

{% for context in route_map.contexts | default([]) %}
{% set context_name = context.name ~ defaults.apic.tenants.policies.route_control_route_maps.contexts.name_suffix %}

Verify Context {{ context_name }} Route Map {{ route_map_name }}
    ${context}=   Set Variable   $..rtctrlProfile.children[?(@.rtctrlCtxP.attributes.name=='{{ context_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${context}..rtctrlCtxP.attributes.name   {{ context_name }}
    Should Be Equal Value Json String   ${r.json()}   ${context}..rtctrlCtxP.attributes.descr   {{ context.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${context}..rtctrlCtxP.attributes.action   {{ context.action | default(defaults.apic.tenants.policies.route_control_route_maps.contexts.action) }}
    Should Be Equal Value Json String   ${r.json()}   ${context}..rtctrlCtxP.attributes.order   {{ context.order | default(defaults.apic.tenants.policies.route_control_route_maps.contexts.order) }}
{% if context.set_rule is defined %}
{% set set_rule_name = context.set_rule ~ defaults.apic.tenants.policies.set_rules.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${context}..rtctrlCtxP.children..rtctrlScope.children..rtctrlRsScopeToAttrP.attributes.tnRtctrlAttrPName   {{ set_rule_name }}
{% endif %}

{% for rule in context.match_rules | default([]) %}
{% set match_rule_name = rule ~ defaults.apic.tenants.policies.match_rules.name_suffix %}

Verify Match Rule {{ match_rule_name }} Context {{ context_name }} Route Map {{ route_map_name }}
    ${context}=   Set Variable   $..rtctrlProfile.children[?(@.rtctrlCtxP.attributes.name=='{{ context_name }}')]
    ${match_rule}=   Set Variable   ${context}..rtctrlCtxP.children[?(@.rtctrlRsCtxPToSubjP.attributes.tnRtctrlSubjPName=='{{ match_rule_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${match_rule}..rtctrlRsCtxPToSubjP.attributes.tnRtctrlSubjPName   {{ match_rule_name }}  
{% endfor %}

{% endfor %}

{% endfor %}
