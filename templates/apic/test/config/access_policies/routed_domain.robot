*** Settings ***
Documentation   Verify Routed Domain
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for domain in apic.access_policies.routed_domains | default([]) %}
{% set domain_name = domain.name ~ defaults.apic.access_policies.routed_domains.name_suffix %}

Verify Routed Domain {{ domain_name }}
    GET   "/api/mo/uni/l3dom-{{ domain_name }}.json?rsp-subtree=full"
    String   $..l3extDomP.attributes.name   {{ domain_name }}
    {% set vlan_pool_name = domain.vlan_pool ~ defaults.apic.access_policies.vlan_pools.name_suffix %}
    {% set query = "vlan_pools[?name==`" ~ vlan_pool_name ~ "`].allocation[]" %}
    {% set allocation = (apic.access_policies | json_query(query))[0] | default(defaults.apic.access_policies.routed_domains.allocation) %}
    String   $..infraRsVlanNs.attributes.tDn   uni/infra/vlanns-[{{ vlan_pool_name }}]-{{ allocation }}

{% endfor %}
