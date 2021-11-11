*** Settings ***
Documentation   Verify External Connectivity Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.fabric_policies is defined and apic.fabric_policies.external_connectivity_policy is defined %}
{% set policy_name = apic.fabric_policies.external_connectivity_policy.name ~ defaults.apic.fabric_policies.external_connectivity_policy.name_suffix %}
Verify External Connectivity Policy
    GET   "/api/mo/uni/tn-infra/fabricExtConnP-{{ apic.fabric_policies.external_connectivity_policy.fabric_id | default(defaults.apic.fabric_policies.external_connectivity_policy.fabric_id) }}.json?rsp-subtree=full"
    String   $..fvFabricExtConnP.attributes.name   {{ policy_name }}
    String   $..fvFabricExtConnP.attributes.rt   {{ apic.fabric_policies.external_connectivity_policy.route_target | default(defaults.apic.fabric_policies.external_connectivity_policy.route_target) }}
    String   $..fvFabricExtConnP.attributes.id   {{ apic.fabric_policies.external_connectivity_policy.fabric_id | default(defaults.apic.fabric_policies.external_connectivity_policy.fabric_id) }}
    String   $..fvFabricExtConnP.attributes.siteId   {{ apic.fabric_policies.external_connectivity_policy.site_id | default(defaults.apic.fabric_policies.external_connectivity_policy.site_id) }}

{% for routing_profile in apic.fabric_policies.external_connectivity_policy.routing_profiles | default([]) %}
{% set routing_profile_name = routing_profile.name ~ defaults.apic.fabric_policies.external_connectivity_policy.routing_profiles.name_suffix %}

Verify External Connectivity Policy Routing Profile {{ routing_profile_name }}
    ${profile}=   Set Variable   $..fvFabricExtConnP.children[?(@.l3extFabricExtRoutingP.attributes.name=='{{ routing_profile_name }}')].l3extFabricExtRoutingP
    String   ${profile}.attributes.name   {{ routing_profile_name }}
{%- for subnet in routing_profile.subnets | default([]) %}

Verify External Connectivity Policy Routing Profile {{ routing_profile_name }} Subnet {{ subnet }} 
    ${profile}=   Set Variable   $..fvFabricExtConnP.children[?(@.l3extFabricExtRoutingP.attributes.name=='{{ routing_profile_name }}')].l3extFabricExtRoutingP
    ${subnet}=   Set Variable    ${profile}.children[?(@.l3extSubnet.attributes.ip=='{{ subnet }}')].l3extSubnet
    String   ${subnet}.attributes.ip   {{ subnet }}

{% endfor %}

{% endfor %}

{% for pod in apic.pod_policies.pods | default([]) %}

Verify External Connectivity Policy Pod {{ pod.id }}
    ${pod}=   Set Variable   $..fvFabricExtConnP.children[?(@.fvPodConnP.attributes.id=='{{ pod.id }}')]
    String   ${pod}..fvPodConnP.attributes.id   {{ pod.id }}
    String   ${pod}..fvIp.attributes.addr   {{ pod.data_plane_tep }}

{% endfor %}

{% endif %}
