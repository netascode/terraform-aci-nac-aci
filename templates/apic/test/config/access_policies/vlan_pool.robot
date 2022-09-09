*** Settings ***
Documentation   Verify VLAN Pool
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pool in apic.access_policies.vlan_pools | default([]) %}
{% set vlan_pool_name = pool.name ~ defaults.apic.access_policies.vlan_pools.name_suffix %}

Verify VLAN Pool {{ vlan_pool_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/vlanns-[{{ vlan_pool_name }}]-{{ pool.allocation | default(defaults.apic.access_policies.vlan_pools.allocation) }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..fvnsVlanInstP.attributes.name   {{ vlan_pool_name }}
    Should Be Equal Value Json String   ${r.json()}    $..fvnsVlanInstP.attributes.descr   {{ pool.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..fvnsVlanInstP.attributes.allocMode   {{ pool.allocation | default(defaults.apic.access_policies.vlan_pools.allocation) }}

{% for range in pool.ranges | default([]) %}

Verify VLAN Pool {{ vlan_pool_name }} Range From {{ range.from }} To {{ range.to | default(range.from) }}
    ${range}=   Set Variable   $..fvnsVlanInstP.children[?(@.fvnsEncapBlk.attributes.from=='vlan-{{ range.from }}')]
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.descr   {{ range.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.allocMode   {{ range.allocation | default(defaults.apic.access_policies.vlan_pools.ranges.allocation) }}
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.from   vlan-{{ range.from }}
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.to   vlan-{{ range.to | default(range.from) }}
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.role   {{ range.role | default(defaults.apic.access_policies.vlan_pools.ranges.role) }}

{% endfor %}

{% endfor %}
