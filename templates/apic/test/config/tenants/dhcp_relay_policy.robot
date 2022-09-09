{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify DHCP Relay Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.dhcp_relay_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix %}

Verify DHCP Relay Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/relayp-{{ policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..dhcpRelayP.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..dhcpRelayP.attributes.descr  {{ policy.description | default() }}

{% for provider in policy.providers | default([]) %}

Verify DHCP Relay Policy {{ policy_name }} Provider {{ provider.ip }}
    ${provider}=   Set Variable   $..dhcpRelayP.children[?(@.dhcpRsProv.attributes.addr=='{{ provider.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${provider}..dhcpRsProv.attributes.addr   {{ provider.ip }}
{% if provider.type == "epg" %}
{% set ap_name = provider.application_profile ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% set epg_name = provider.endpoint_group ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..dhcpRsProv.attributes.tDn   uni/tn-{{ provider.tenant | default(tenant.name) }}/ap-{{ ap_name }}/epg-{{ epg_name }}
{% elif provider.type == "external_epg" %}
{% set l3out_name = provider.l3out ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set eepg_name = provider.external_endpoint_group ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..dhcpRsProv.attributes.tDn   uni/tn-{{ provider.tenant | default(tenant.name) }}/out-{{ l3out_name }}/instP-{{ eepg_name }}
{% endif %}

{% endfor %}

{% endfor %}
