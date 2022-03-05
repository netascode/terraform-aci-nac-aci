*** Settings ***
Documentation   Verify Trust Contol Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for policy in tenant.policies.trust_control_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.tenants.policies.trust_control_policies.name_suffix %}

Verify Trust Control Policy {{ policy_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/trustctrlpol-{{ policy_name }}.json"
    String   $..fhsTrustCtrlPol.attributes.name   {{ policy_name }}
    String   $..fhsTrustCtrlPol.attributes.descr   {{ policy.description | default()}}
    String   $..fhsTrustCtrlPol.attributes.hasDhcpv4Server   {{ policy.dhcp_v4_server | default(defaults.apic.tenants.policies.trust_control_policies.dhcp_v4_server) | cisco.aac.aac_bool("yes") }}
    String   $..fhsTrustCtrlPol.attributes.hasDhcpv6Server   {{ policy.dhcp_v6_server | default(defaults.apic.tenants.policies.trust_control_policies.dhcp_v6_server) | cisco.aac.aac_bool("yes") }}
    String   $..fhsTrustCtrlPol.attributes.hasIpv6Router   {{ policy.ipv6_router | default(defaults.apic.tenants.policies.trust_control_policies.ipv6_router) | cisco.aac.aac_bool("yes") }}
    String   $..fhsTrustCtrlPol.attributes.trustArp   {{ policy.arp | default(defaults.apic.tenants.policies.trust_control_policies.arp) | cisco.aac.aac_bool("yes") }}
    String   $..fhsTrustCtrlPol.attributes.trustNd   {{ policy.nd | default(defaults.apic.tenants.policies.trust_control_policies.nd) | cisco.aac.aac_bool("yes") }}
    String   $..fhsTrustCtrlPol.attributes.trustRa   {{ policy.ra | default(defaults.apic.tenants.policies.trust_control_policies.ra) | cisco.aac.aac_bool("yes") }}

{% endfor %}
