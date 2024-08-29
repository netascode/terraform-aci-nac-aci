*** Settings ***
Documentation   Verify RBAC Node Rule
Suite Setup     Login APIC
Default Tags    apic   day1   config   node_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for node in apic.node_policies.nodes | default([]) %}
{% if node.role == "leaf" and node.security_domains is defined %}

Verify RBAC Node Rule {{ node.id }}
    ${r}=   GET On Session   apic   /api/mo/uni/rbacdb/rbacnoderule-{{ node.id }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..aaaRbacNodeRule.attributes.nodeId   {{ node.id }}

{% for sd in node.security_domains %}

Verify RBAC Node Rule {{ node.id }} Security Domain {{ sd }}
    ${sd}=   Set Variable   $..aaaRbacNodeRule.children[?(@.aaaRbacPortRule.attributes.name=='{{ sd }}')]
    Should Be Equal Value Json String   ${r.json()}    ${sd}..aaaRbacPortRule.attributes.domain   {{ sd }}

{% endfor %}

{% endif %}
{% endfor %}
