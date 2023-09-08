*** Settings ***
Documentation   Verify Routed Domain
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for domain in apic.access_policies.routed_domains | default([]) %}
{% set domain_name = domain.name ~ defaults.apic.access_policies.routed_domains.name_suffix %}

Verify Routed Domain {{ domain_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/l3dom-{{ domain_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..l3extDomP.attributes.name   {{ domain_name }}
    {% set vlan_pool_name = domain.vlan_pool ~ defaults.apic.access_policies.vlan_pools.name_suffix %}
    {% set query = "vlan_pools[?name==`" ~ vlan_pool_name ~ "`].allocation[]" %}
    {% set allocation = (apic.access_policies | community.general.json_query(query))[0] | default(defaults.apic.access_policies.routed_domains.allocation) %}
    Should Be Equal Value Json String   ${r.json()}    $..infraRsVlanNs.attributes.tDn   uni/infra/vlanns-[{{ vlan_pool_name }}]-{{ allocation }}

Verify Routed Domain {{ domain_name }} Security Domains
    ${r}=   GET On Session   apic   /api/mo/uni/l3dom-{{ domain.name }}.json    params=query-target=children&target-subtree-class=aaaDomainRef
{% for sd in domain.security_domains | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   $..imdata[?(@.aaaDomainRef.attributes.name=='{{ sd }}')].aaaDomainRef.attributes.name   {{ sd }}
{% endfor %}

{% endfor %}
