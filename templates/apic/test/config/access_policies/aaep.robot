*** Settings ***
Documentation   Verify AAEP
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for aaep in apic.access_policies.aaeps | default([]) %}
{% set aaep_name = aaep.name ~ defaults.apic.access_policies.aaeps.name_suffix %}

Verify AAEP {{ aaep_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/attentp-{{ aaep_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..infraAttEntityP.attributes.name   {{ aaep_name }}
{% if aaep.infra_vlan | default(defaults.apic.access_policies.aaeps.infra_vlan) | cisco.aac.aac_bool("enabled") == 'enabled' %}
    Should Be Equal Value Json String   ${r.json()}    $..infraProvAcc..infraRsFuncToEpg.attributes.encap   vlan-{{ apic.access_policies.infra_vlan }}
{% endif %}

{% for dom in aaep.physical_domains | default([]) %}
{% set domain_name = dom ~ defaults.apic.access_policies.physical_domains.name_suffix %}

Verify AAEP {{ aaep_name }} Physical Domain {{ domain_name }}
    ${domain}=   Set Variable   $..infraAttEntityP.children[?(@.infraRsDomP.attributes.tDn=='uni/phys-{{ domain_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${domain}..infraRsDomP.attributes.tDn   uni/phys-{{ domain_name }}

{% endfor %}

{% for dom in aaep.routed_domains | default([]) %}
{% set domain_name = dom ~ defaults.apic.access_policies.routed_domains.name_suffix %}

Verify AAEP {{ aaep_name }} Routed Domain {{ domain_name }}
    ${domain}=   Set Variable   $..infraAttEntityP.children[?(@.infraRsDomP.attributes.tDn=='uni/l3dom-{{ domain_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${domain}..infraRsDomP.attributes.tDn   uni/l3dom-{{ domain_name }}

{% endfor %}

{% for dom in aaep.vmware_vmm_domains | default([]) %}
{% set domain_name = dom ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}

Verify AAEP {{ aaep_name }} VMM Domain {{ domain_name }}
    ${domain}=   Set Variable   $..infraAttEntityP.children[?(@.infraRsDomP.attributes.tDn=='uni/vmmp-VMware/dom-{{ domain_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${domain}..infraRsDomP.attributes.tDn   uni/vmmp-VMware/dom-{{ domain_name }}

{% endfor %}

{% if aaep.endpoint_groups is defined %}
{% for epg in aaep.endpoint_groups | default([]) %}
{% set ap_name = epg.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set epg_name = epg.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}

Verify AAEP {{ aaep_name }} Endpoint Group {{ epg_name }} Tenant {{ epg.tenant }} AP {{ ap_name }}
    ${epg}=   Set Variable   $..infraGeneric.children[?(@.infraRsFuncToEpg.attributes.tDn=='uni/tn-{{ epg.tenant }}/ap-{{ ap_name }}/epg-{{ epg_name }}')]
{% if epg.primary_vlan is defined %}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.encap   vlan-{{ epg.secondary_vlan }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.encap   vlan-{{ epg.vlan }}
{% endif %}
{% if epg.primary_vlan is defined %}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.primaryEncap   vlan-{{ epg.primary_vlan }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.primaryEncap   unknown
{% endif %}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.instrImedcy   {{ epg.deployment_immediacy | default(defaults.apic.access_policies.aaeps.endpoint_groups.deployment_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.mode   {{ epg.mode | default(defaults.apic.access_policies.aaeps.endpoint_groups.mode) }}
    Should Be Equal Value Json String   ${r.json()}    ${epg}..infraRsFuncToEpg.attributes.tDn   uni/tn-{{ epg.tenant }}/ap-{{ ap_name }}/epg-{{ epg_name }}

{% endfor %}
{% endif %}

{% endfor %}
