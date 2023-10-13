{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify ND RA Prefix Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for nd_ra_prefix_pol in tenant.policies.nd_ra_prefix_policies | default([]) %}
{% set policy_name = nd_ra_prefix_pol.name ~ defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix %}
{% set ctrl = [] %}
{% if nd_ra_prefix_pol.auto_configuration | default(defaults.apic.tenants.policies.nd_ra_prefix_policies.auto_configuration) %}{% set ctrl = ctrl + [("auto-cfg")] %}{% endif %}
{% if nd_ra_prefix_pol.on_link | default(defaults.apic.tenants.policies.nd_ra_prefix_policies.on_link) %}{% set ctrl = ctrl + [("on-link")] %}{% endif %}
{% if nd_ra_prefix_pol.router_address | default(defaults.apic.tenants.policies.nd_ra_prefix_policies.router_address) %}{% set ctrl = ctrl + [("router-address")] %}{% endif %}

Verify ND RA Prefix Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ndpfxpol-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..ndPfxPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..ndPfxPol.attributes.descr   {{ nd_ra_prefix_pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..ndPfxPol.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   $..ndPfxPol.attributes.lifetime   {{ nd_ra_prefix_pol.valid_lifetime | default(defaults.apic.tenants.policies.nd_ra_prefix_policies.valid_lifetime) }}                   
    Should Be Equal Value Json String   ${r.json()}   $..ndPfxPol.attributes.prefLifetime   {{ nd_ra_prefix_pol.preferred_lifetime | default(defaults.apic.tenants.policies.nd_ra_prefix_policies.preferred_lifetime) }}

{% endfor %}
