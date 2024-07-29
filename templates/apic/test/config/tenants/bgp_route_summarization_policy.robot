{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BGP Route Summarization Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for brs in tenant.policies.bgp_route_summarization_policies | default([]) %}
{% set policy_name = brs.name ~ defaults.apic.tenants.policies.bgp_route_summarization_policies.name_suffix %}
{% set ctrl = [] %}
{% if brs.as_set | default(defaults.apic.tenants.policies.bgp_route_summarization_policies.as_set) %}{% set ctrl = ctrl + [("as-set")] %}{% endif %}
{% if brs.summary_only | default(defaults.apic.tenants.policies.bgp_route_summarization_policies.summary_only) %}{% set ctrl = ctrl + [("summary-only")] %}{% endif %}
{% set addrTCtrl = [] %}
{% if brs.af_mcast | default(defaults.apic.tenants.policies.bgp_route_summarization_policies.af_mcast) %}{% set addrTCtrl = addrTCtrl + [("af-mcast")] %}{% endif %}
{% if brs.af_ucast | default(defaults.apic.tenants.policies.bgp_route_summarization_policies.af_ucast) %}{% set addrTCtrl = addrTCtrl + [("af-ucast")] %}{% endif %}

Verify BGP Route Summarization Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/bgprtsum-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bgpRtSummPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpRtSummPol.attributes.descr   {{ brs.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpRtSummPol.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpRtSummPol.attributes.addrTCtrl   {{ addrTCtrl | join(',') }}

{% endfor %}
