{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Bridge Domain
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for bd in tenant.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.apic.tenants.bridge_domains.name_suffix %}
{% set vrf_name = bd.vrf ~ ('' if bd.vrf in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}

Verify Bridge Domain {{ bd_name }}
{%- set bd_move_detection = "" %}
{%- if bd.ep_move_detection | default(defaults.apic.tenants.bridge_domains.ep_move_detection) | cisco.aac.aac_bool("enabled") == "enabled" %}
{%- set bd_move_detection = "garp" %}
{%- endif %}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/BD-{{ bd_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.arpFlood   {{ bd.arp_flooding | default(defaults.apic.tenants.bridge_domains.arp_flooding) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.descr   {{ bd.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.hostBasedRouting   {{ bd.advertise_host_routes | default(defaults.apic.tenants.bridge_domains.advertise_host_routes) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.ipLearning   {{ bd.ip_dataplane_learning | default(defaults.apic.tenants.bridge_domains.ip_dataplane_learning) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.limitIpLearnToSubnets  {{ bd.limit_ip_learn_to_subnets | default(defaults.apic.tenants.bridge_domains.limit_ip_learn_to_subnets) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.mac   {{ bd.mac | default(defaults.apic.tenants.bridge_domains.mac) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.vmac   {{ bd.virtual_mac | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.mcastAllow   {{ bd.l3_multicast | default(defaults.apic.tenants.bridge_domains.l3_multicast) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.multiDstPktAct   {{ bd.multi_destination_flooding | default(defaults.apic.tenants.bridge_domains.multi_destination_flooding) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.nameAlias   {{ bd.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.unicastRoute   {{ bd.unicast_routing | default(defaults.apic.tenants.bridge_domains.unicast_routing) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.unkMacUcastAct   {{ bd.unknown_unicast | default(defaults.apic.tenants.bridge_domains.unknown_unicast) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.unkMcastAct   {{ bd.unknown_ipv4_multicast | default(defaults.apic.tenants.bridge_domains.unknown_ipv4_multicast) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.v6unkMcastAct   {{ bd.unknown_ipv6_multicast | default(defaults.apic.tenants.bridge_domains.unknown_ipv6_multicast) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvRsCtx.attributes.tnFvCtxName   {{ vrf_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.attributes.epMoveDetectMode   {{ bd_move_detection }}

{% for dhcp_label in bd.dhcp_labels | default([]) %}
{% set dhcp_relay_policy_name = dhcp_label.dhcp_relay_policy ~ defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix %}

Verify Bridge Domain {{ bd_name }} DHCP Relay Policy {{ dhcp_relay_policy_name }}
    ${dhcp_label}=   Set Variable   $..fvBD.children[?(@.dhcpLbl.attributes.name=='{{ dhcp_relay_policy_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${dhcp_label}..dhcpLbl.attributes.name   {{ dhcp_relay_policy_name }}
    Should Be Equal Value Json String   ${r.json()}   ${dhcp_label}..dhcpLbl.attributes.descr   {{ dhcp_label.description | default() }} 
{% if dhcp_label.dhcp_option_policy is defined %}
{% set dhcp_option_policy_name = dhcp_label.dhcp_option_policy ~ defaults.apic.tenants.policies.dhcp_option_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${dhcp_label}..dhcpRsDhcpOptionPol.attributes.tnDhcpOptionPolName   {{ dhcp_option_policy_name }}
{% endif %}

{% endfor %}

{% for subnet in bd.subnets | default([]) %}
{% set scope = [] %}
{% if subnet.private | default(defaults.apic.tenants.bridge_domains.subnets.private) and not (subnet.public | default(defaults.apic.tenants.bridge_domains.subnets.public)) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("private")] %}{% endif %}
{% if subnet.public | default(defaults.apic.tenants.bridge_domains.subnets.public) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("public")] %}{% endif %}
{% if subnet.shared | default(defaults.apic.tenants.bridge_domains.subnets.shared) | cisco.aac.aac_bool("yes") == "yes" %}{% set scope = scope + [("shared")] %}{% endif %}
{% set ctrl = [] %}
{% if subnet.nd_ra_prefix | default(defaults.apic.tenants.bridge_domains.subnets.nd_ra_prefix) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("nd")] %}{% endif %}
{% if subnet.no_default_gateway | default(defaults.apic.tenants.bridge_domains.subnets.no_default_gateway) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("no-default-gateway")] %}{% endif %}
{% if subnet.igmp_querier | default(defaults.apic.tenants.bridge_domains.subnets.igmp_querier) | cisco.aac.aac_bool("yes") == "yes" %}{% set ctrl = ctrl + [("querier")] %}{% endif %}

Verify Bridge Domain {{ bd_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $..fvBD.children[?(@.fvSubnet.attributes.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.descr   {{ subnet.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.preferred   {{ subnet.primary_ip | default(defaults.apic.tenants.bridge_domains.subnets.primary_ip) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.scope   {{ scope | join(',') }}   
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.virtual   {{ subnet.virtual | default(defaults.apic.tenants.bridge_domains.subnets.virtual) | cisco.aac.aac_bool("yes") }}               

{% endfor %}

{% for l3out in bd.l3outs | default([]) %}
{% set l3out_name = l3out ~ defaults.apic.tenants.l3outs.name_suffix %}

Verify Bridge Domain {{ bd_name }} L3out {{ l3out_name }}
    ${l3out}=   Set Variable   $..fvBD.children[?(@.fvRsBDToOut.attributes.tnL3extOutName=='{{ l3out_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${l3out}..fvRsBDToOut.attributes.tnL3extOutName   {{ l3out_name }}

{% endfor %}

{% if bd.igmp_interface_policy is defined %}
{% set igmp_interface_policy_name = bd.igmp_interface_policy ~ defaults.apic.tenants.policies.igmp_interface_policies.name_suffix %}

Verify Bridge Domain {{ bd_name }} IGMP Interface Policy
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.children..igmpIfP.children..igmpRsIfPol.attributes.tDn   uni/tn-{{ tenant.name }}/igmpIfPol-{{ igmp_interface_policy_name }}

{% endif %}

{% if bd.igmp_snooping_policy is defined %}
{% set igmp_snooping_policy_name = bd.igmp_snooping_policy ~ defaults.apic.tenants.policies.igmp_snooping_policies.name_suffix %}
                        
Verify Bridge Domain {{ bd_name }} IGMP Snooping Policy
    Should Be Equal Value Json String   ${r.json()}   $..fvBD.children..fvRsIgmpsn.attributes.tnIgmpSnoopPolName   {{ igmp_snooping_policy_name }}

{% endif %}

{% endfor %}
