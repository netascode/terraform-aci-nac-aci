*** Settings ***
Documentation   Verify Schema
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
{% for schema in mso.schemas | default([]) %}

Verify Schema {{ schema.name }}
    GET   "/api/v1/schemas/%%schemas%{{ schema.name }}%%"
    String   $.displayName   {{ schema.name }}

{% for template in schema.templates | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }}
    ${template}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')]
    String   ${template}.name   {{ template.name }}

{% for ap in template.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }}
    ${ap}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')]
    String   ${ap}.name   {{ ap_name }}
    String   ${ap}.displayName   {{ ap_name }}

{% for epg in ap.endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.mso.schemas.templates.application_profiles.endpoint_groups.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')]
    String   ${epg}.name   {{ epg_name }}
    String   ${epg}.displayName   {{ epg_name }}
    Boolean   ${epg}.uSegEpg   {% if epg.useg | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.useg) == "enabled" %}true{% else %}false{% endif %} 
    String   ${epg}.intraEpg   {% if epg.proxy_arp | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.proxy_arp) == "enabled" %}"enforced"{% else %}"unenforced"{% endif %}
    Boolean   ${epg}.proxyArp   {% if epg.proxy_arp | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.proxy_arp) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${epg}.preferredGroup   {% if epg.preferred_group | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.preferred_group) == "enabled" %}true{% else %}false{% endif %} 
{% if epg.bridge_domain.name is defined %}
{% set bd_name = epg.bridge_domain.name ~ defaults.mso.schemas.templates.bridge_domains.name_suffix %}
    String   ${epg}.bdRef   /schemas/%%schemas%{{ epg.bridge_domain.schema | default(schema.name) }}%%/templates/{{ epg.bridge_domain.template | default(template.name) }}/bds/{{ bd_name }}
{% endif %}
{% if epg.vrf.name is defined %}
{% set vrf_name = epg.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}
    String   ${epg}.vrfRef   /schemas/%%schemas%{{ epg.vrf.schema | default(schema.name) }}%%/templates/{{ epg.vrf.template | default(template.name) }}/vrfs/{{ vrf_name }}
{% endif %}

{% for subnet in epg.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    String   ${subnet}.ip   {{ subnet.ip }}
    String   ${subnet}.scope   {{ subnet.scope | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.scope) }}
    Boolean   ${subnet}.shared   {% if subnet.shared | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.shared) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${subnet}.noDefaultGateway   {% if subnet.no_default_gateway | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.no_default_gateway) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Boolean   ${subnet}.primary   {% if subnet.primary | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.primary) == "enabled" %}true{% else %}false{% endif %} 
{% endif %}
{% endfor %}

{% endfor %}

{% endfor %}

{% for vrf in template.vrfs | default([]) %}
{% set vrf_name = vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} VRF {{ vrf_name }}
    ${vrf}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')]
    String   ${vrf}.name   {{ vrf_name }}
    String   ${vrf}.displayName   {{ vrf_name }}
    Boolean   ${vrf}.preferredGroup   {% if vrf.preferred_group | default(defaults.mso.schemas.templates.vrfs.preferred_group) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${vrf}.l3MCast   {% if vrf.l3_multicast | default(defaults.mso.schemas.templates.vrfs.l3_multicast) == "enabled" %}true{% else %}false{% endif %} 

{% endfor %}

{% for bd in template.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.mso.schemas.templates.bridge_domains.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }}
    ${bd}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')]
    String   ${bd}.name   {{ bd_name }}
    String   ${bd}.displayName   {{ bd_name }}
    String   ${bd}.l2UnknownUnicast   {{ bd.l2_unknown_unicast | default(defaults.mso.schemas.templates.bridge_domains.l2_unknown_unicast)}}
    Boolean   ${bd}.intersiteBumTrafficAllow   {% if bd.intersite_bum_traffic | default(defaults.mso.schemas.templates.bridge_domains.intersite_bum_traffic) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${bd}.optimizeWanBandwidth   {% if bd.optimize_wan_bandwidth | default(defaults.mso.schemas.templates.bridge_domains.optimize_wan_bandwidth) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${bd}.l2Stretch   {% if bd.l2_stretch | default(defaults.mso.schemas.templates.bridge_domains.l2_stretch) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${bd}.l3MCast   {% if bd.l3_multicast | default(defaults.mso.schemas.templates.bridge_domains.l3_multicast) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Boolean   ${bd}.unicastRouting  {% if bd.unicast_routing | default(defaults.mso.schemas.templates.bridge_domains.unicast_routing) == "enabled" %}true{% else %}false{% endif %}
{% endif %}

{% if mso.version | default(defaults.mso.version) is version('3.1.1g', '>=') %}
    Boolean   ${bd}.arpFlood   {% if bd.arp_flooding | default(defaults.mso.schemas.templates.bridge_domains.arp_flooding) == "enabled" %}true{% else %}false{% endif %}
{% endif %}

{% if bd.dhcp_relay_policy is defined %}
{% set dhcp_relay_policy_name = bd.dhcp_relay_policy ~ defaults.mso.policies.dhcp_relays.name_suffix %}
    String   ${bd}.dhcpLabel.name   {{ dhcp_relay_policy_name }}
{% if bd.dhcp_option_policy is defined %}
{% set dhcp_option_name = bd.dhcp_option_policy ~ defaults.mso.policies.dhcp_options.name_suffix %}
    String   ${bd}.dhcpLabel.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endif %}

{% if bd.dhcp_policies is defined and mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
{% for pol in  bd.dhcp_policies | default([]) %}
{% set dhcp_relay_policy_name = pol.dhcp_relay_policy ~ defaults.mso.policies.dhcp_relays.name_suffix %}
    ${dhcp}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].dhcpLabels[?(@.name=='{{ dhcp_relay_policy_name }}')]                     
    String   ${dhcp}.name   {{ dhcp_relay_policy_name }}
{% if pol.dhcp_option_policy is defined %}
{% set dhcp_option_name = pol.dhcp_option_policy ~ defaults.mso.policies.dhcp_options.name_suffix %}
    String   ${dhcp}.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endfor %}
{% endif %}


{% for subnet in bd.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    String   ${subnet}.ip   {{ subnet.ip }}
    String   ${subnet}.scope   {{ subnet.scope | default(defaults.mso.schemas.templates.bridge_domains.subnets.scope) }}
    Boolean   ${subnet}.shared   {% if subnet.shared | default(defaults.mso.schemas.templates.bridge_domains.subnets.shared) == "enabled" %}true{% else %}false{% endif %} 
    Boolean   ${subnet}.querier   {% if subnet.querier | default(defaults.mso.schemas.templates.bridge_domains.subnets.querier) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Boolean   ${subnet}.primary   {% if subnet.primary | default(defaults.mso.schemas.templates.bridge_domains.subnets.primary) == "enabled" %}true{% else %}false{% endif %} 
{% endif %}
{% endfor %}

{% endfor %}

{% for contract in template.contracts | default([]) %}
{% set contract_name = contract.name ~ defaults.mso.schemas.templates.contracts.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Contract {{ contract_name }}
    ${contract}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].contracts[?(@.name=='{{ contract_name }}')]
    String   ${contract}.name   {{ contract_name }}
    String   ${contract}.displayName   {{ contract_name }}
    String   ${contract}.scope   {{ contract.scope | default(defaults.mso.schemas.templates.contracts.scope) }}
    String   ${contract}.filterType   {{ contract.type | default(defaults.mso.schemas.templates.contracts.type) }}

{% endfor %}

{% for filter in template.filters | default([]) %}
{% set filter_name = filter.name ~ defaults.mso.schemas.templates.filters.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')]
    String   ${filter}.name   {{ filter_name }}
    String   ${filter}.displayName   {{ filter_name }}

{% for entry in filter.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.mso.schemas.templates.filters.entries.name_suffix %}

{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }} Entry {{ entry_name }}
    ${entry}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')].entries[?(@.name=='{{ entry_name }}')]
    String   ${entry}.description   {{ entry.description | default() }}
    String   ${entry}.etherType   {{ entry.ethertype | default(defaults.mso.schemas.templates.filters.entries.ethertype) }}
{% if entry.ethertype | default(defaults.mso.schemas.templates.filters.entries.ethertype) in ['ip', 'ipv4', 'ipv6'] %}
    String   ${entry}.ipProtocol   {{ entry.protocol | default(defaults.mso.schemas.templates.filters.entries.protocol) }}
{% else %}
    String   ${entry}.ipProtocol   unspecified
{% endif %}
    Boolean   ${entry}.stateful   {% if entry.stateful | default(defaults.mso.schemas.templates.filters.entries.stateful) == "enabled" %}true{% else %}false{% endif %} 
    String   ${entry}.sourceFrom   {{ get_protocol_from_port(entry.source_from_port | default(defaults.mso.schemas.templates.filters.entries.source_from_port)) }}
    String   ${entry}.sourceTo   {{ get_protocol_from_port(entry.source_to_port | default(entry.source_from_port | default(defaults.mso.schemas.templates.filters.entries.source_from_port))) }}
    String   ${entry}.destinationFrom   {{ get_protocol_from_port(entry.destination_from_port | default(defaults.mso.schemas.templates.filters.entries.destination_from_port)) }}
    String   ${entry}.destinationTo   {{ get_protocol_from_port(entry.destination_to_port | default(entry.destination_from_port | default(defaults.mso.schemas.templates.filters.entries.destination_from_port))) }}

{% endfor %}

{% endfor %}

{% for epg in template.external_endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.mso.schemas.templates.external_endpoint_groups.name_suffix %}
{% set vrf_name = epg.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')]
    String   ${epg}.name   {{ epg_name }}
    String   ${epg}.displayName   {{ epg_name }}
    Boolean   ${epg}.preferredGroup   {% if epg.preferred_group | default() == "enabled" %}true{% else %}false{% endif %} 
{% if epg.l3out.name is defined %}
{% set l3out_name = epg.l3out.name ~ defaults.mso.schemas.templates.l3outs.name_suffix %}
    String   ${epg}.l3outRef   /schemas/%%schemas%{{ epg.l3out.schema | default(schema.name) }}%%/templates/{{ epg.l3out.template | default(template.name) }}/l3outs/{{ l3out_name }}
{% endif %}
{% if epg.application_profile.name is defined %}
{% set ap_name = epg.application_profile.name ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}
    String   ${epg}.anpRef   /schemas/%%schemas%{{ epg.application_profile.schema | default(schema.name) }}%%/templates/{{ epg.application_profile.template | default(template.name) }}/anps/{{ ap_name }}
{% endif %}

{% for subnet in epg.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }} Subnet {{ subnet.prefix }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.prefix }}')]
    String   ${subnet}.ip   {{ subnet.prefix }}

{% endfor %}

{% endfor %}

{% for sg in template.service_graphs | default([]) %}
{% set sg_name = sg.name ~ defaults.mso.schemas.templates.service_graphs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }}
    ${sg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')]
    String   ${sg}.name   {{ sg_name }}
    String   ${sg}.displayName   {{ sg_name }}
    String   ${sg}.description   {{ sg.description | default() }}

{%- for node in sg.nodes | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }} Node {{ node.name }}
    ${node}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')].serviceNodes[?(@.name=='{{ node.name }}')]
    String   ${node}.name   {{ node.name }}

{% endfor %}

{% endfor %}

{% for l3out in template.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.mso.schemas.templates.l3outs.name_suffix %}
{% set vrf_name = l3out.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} L3out {{ l3out_name }}
    ${l3out}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].intersiteL3outs[?(@.name=='{{ l3out_name }}')]
    String   ${l3out}.name   {{ l3out_name }}
    String   ${l3out}.displayName   {{ l3out_name }}

{% endfor %}

{% endfor %}

{% endfor %}
