{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify DHCP Option Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.dhcp_option_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.dhcp_option_policies.name_suffix %}

Verify DHCP Option Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/dhcpoptpol-{{ policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..dhcpOptionPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..dhcpOptionPol.attributes.descr  {{ policy.description | default() }}

{% for option in policy.options | default([]) %}
{% set option_name = option.name ~ defaults.apic.tenants.policies.dhcp_option_policies.options.name_suffix %}

Verify DHCP Option Policy {{ policy_name }} Option {{ option_name }}
    ${option}=   Set Variable   $..dhcpOptionPol.children[?(@.dhcpOption.attributes.name=='{{ option_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${option}..dhcpOption.attributes.name   {{ option_name }}
    Should Be Equal Value Json String   ${r.json()}   ${option}..dhcpOption.attributes.id   {{ option.id | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${option}..dhcpOption.attributes.data   {{ option.data | default() }}

{% endfor %}

{% endfor %}
