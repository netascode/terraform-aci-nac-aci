*** Settings ***
Documentation   Verify MST Switch Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.switch_policies.mst_policies | default([]) %}
{% set mst_policy_name = policy.name ~ defaults.apic.access_policies.switch_policies.mst_policies.name_suffix %}

Verify MST Switch Policy {{ mst_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/mstpInstPol-default/mstpRegionPol-{{ mst_policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..stpMstRegionPol.attributes.name   {{ mst_policy_name }}

{% for inst in policy.instances | default([]) %}

Verify MST Switch Policy {{ mst_policy_name }} Instance {{ inst.name }}
    ${inst}=   Set Variable   $..stpMstRegionPol.children[?(@.stpMstDomPol.attributes.name=='{{ inst.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${inst}..stpMstDomPol.attributes.name   {{ inst.name }}
    Should Be Equal Value Json String   ${r.json()}    ${inst}..stpMstDomPol.attributes.id   {{ inst.id }}

{% for range in inst.vlan_ranges | default([]) %}

Verify MST Switch Policy {{ mst_policy_name }} Instance {{ inst.name }} Range VLAN {{ range.from }}-{{ range.to | default(range.from) }}
    ${inst}=   Set Variable   $..stpMstRegionPol.children[?(@.stpMstDomPol.attributes.name=='{{ inst.name }}')]
    ${range}=   Set Variable   ${inst}..stpMstDomPol.children[?(@.fvnsEncapBlk.attributes.from=='vlan-{{ range.from }}')]
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.from   vlan-{{ range.from }}
    Should Be Equal Value Json String   ${r.json()}    ${range}..fvnsEncapBlk.attributes.to   vlan-{{ range.to | default(range.from) }}

{% endfor %}

{% endfor %}

{% endfor %}
