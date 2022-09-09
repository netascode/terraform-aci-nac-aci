{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify BGP Best Path Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bpp in tenant.policies.bgp_best_path_policies | default([]) %}
{% set bpp_name = bpp.name ~ defaults.apic.tenants.policies.bgp_best_path_policies.name_suffix %}
{% set control_type = "" %}
{% if bpp.control_type | default(defaults.apic.tenants.policies.bgp_best_path_policies.control_type) == "multi-path-relax" %}{% set control_type = "asPathMultipathRelax" %}{% endif %}

Verify BGP Best Path Policy {{ bpp_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/bestpath-{{ bpp_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bgpBestPathCtrlPol.attributes.name    {{ bpp_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpBestPathCtrlPol.attributes.descr    {{ bpp.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bgpBestPathCtrlPol.attributes.ctrl    {{ control_type }}
{% endfor %}
