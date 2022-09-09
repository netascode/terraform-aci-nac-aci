*** Settings ***
Documentation   Verify Schema
Suite Setup     Login MSO
Default Tags    mso   config   day2
Resource        ../../mso_common.resource

*** Test Cases ***
{% for schema in mso.schemas | default([]) %}

Verify Schema {{ schema.name }}
    ${r}=   GET On Session   mso   /api/v1/schemas/%%schemas%{{ schema.name }}%%
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.displayName   {{ schema.name }}

{% for template in schema.templates | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }}
    ${template}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${template}.name   {{ template.name }}

{% for ap in template.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }}
    ${ap}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${ap}.name   {{ ap_name }}
    Should Be Equal Value Json String   ${r.json()}   ${ap}.displayName   {{ ap_name }}

{% for epg in ap.endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.mso.schemas.templates.application_profiles.endpoint_groups.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.displayName   {{ epg_name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.uSegEpg   {% if epg.useg | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.useg) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   ${epg}.intraEpg   {% if epg.proxy_arp | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.proxy_arp) == "enabled" %}"enforced"{% else %}unenforced{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.proxyArp   {% if epg.proxy_arp | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.proxy_arp) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.preferredGroup   {% if epg.preferred_group | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.preferred_group) == "enabled" %}true{% else %}false{% endif %} 
{% if epg.bridge_domain.name is defined %}
{% set bd_name = epg.bridge_domain.name ~ defaults.mso.schemas.templates.bridge_domains.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.bdRef   /schemas/%%schemas%{{ epg.bridge_domain.schema | default(schema.name) }}%%/templates/{{ epg.bridge_domain.template | default(template.name) }}/bds/{{ bd_name }}
{% endif %}
{% if epg.vrf.name is defined %}
{% set vrf_name = epg.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.vrfRef   /schemas/%%schemas%{{ epg.vrf.schema | default(schema.name) }}%%/templates/{{ epg.vrf.template | default(template.name) }}/vrfs/{{ vrf_name }}
{% endif %}

{% for subnet in epg.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {% if subnet.shared | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.shared) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.noDefaultGateway   {% if subnet.no_default_gateway | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.no_default_gateway) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {% if subnet.primary | default(defaults.mso.schemas.templates.application_profiles.endpoint_groups.subnets.primary) == "enabled" %}true{% else %}false{% endif %} 
{% endif %}
{% endfor %}

{% endfor %}

{% endfor %}

{% for vrf in template.vrfs | default([]) %}
{% set vrf_name = vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} VRF {{ vrf_name }}
    ${vrf}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.name   {{ vrf_name }}
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.displayName   {{ vrf_name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.preferredGroup   {% if vrf.preferred_group | default(defaults.mso.schemas.templates.vrfs.preferred_group) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.l3MCast   {% if vrf.l3_multicast | default(defaults.mso.schemas.templates.vrfs.l3_multicast) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.vzAnyEnabled   {% if vrf.vzany | default(defaults.mso.schemas.templates.vrfs.vzany) == "enabled" %}true{% else %}false{% endif %} 
{% for contract in vrf.contracts.consumers | default([]) %}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')].vzAnyConsumerContracts[?(@.contractRef=='/schemas/%%schemas%{{ contract.schema | default(schema.name) }}%%/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/%%schemas%{{ contract.schema | default(schema.name) }}%%/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract.name }}
{% endfor %}
{% for contract in vrf.contracts.providers | default([]) %}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')].vzAnyProviderContracts[?(@.contractRef=='/schemas/%%schemas%{{ contract.schema | default(schema.name) }}%%/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/%%schemas%{{ contract.schema | default(schema.name) }}%%/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract.name }}
{% endfor %}                        
{% endfor %}

{% for bd in template.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.mso.schemas.templates.bridge_domains.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }}
    ${bd}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${bd}.name   {{ bd_name }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.displayName   {{ bd_name }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.l2UnknownUnicast   {{ bd.l2_unknown_unicast | default(defaults.mso.schemas.templates.bridge_domains.l2_unknown_unicast)}}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.intersiteBumTrafficAllow   {% if bd.intersite_bum_traffic | default(defaults.mso.schemas.templates.bridge_domains.intersite_bum_traffic) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.optimizeWanBandwidth   {% if bd.optimize_wan_bandwidth | default(defaults.mso.schemas.templates.bridge_domains.optimize_wan_bandwidth) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.l2Stretch   {% if bd.l2_stretch | default(defaults.mso.schemas.templates.bridge_domains.l2_stretch) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.l3MCast   {% if bd.l3_multicast | default(defaults.mso.schemas.templates.bridge_domains.l3_multicast) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.unicastRouting  {% if bd.unicast_routing | default(defaults.mso.schemas.templates.bridge_domains.unicast_routing) == "enabled" %}true{% else %}false{% endif %}
{% endif %}

{% if mso.version | default(defaults.mso.version) is version('3.1.1g', '>=') %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.arpFlood   {% if bd.arp_flooding | default(defaults.mso.schemas.templates.bridge_domains.arp_flooding) == "enabled" %}true{% else %}false{% endif %}
{% endif %}

{% if bd.dhcp_relay_policy is defined %}
{% set dhcp_relay_policy_name = bd.dhcp_relay_policy ~ defaults.mso.policies.dhcp_relays.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.dhcpLabel.name   {{ dhcp_relay_policy_name }}
{% if bd.dhcp_option_policy is defined %}
{% set dhcp_option_name = bd.dhcp_option_policy ~ defaults.mso.policies.dhcp_options.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.dhcpLabel.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endif %}

{% if bd.dhcp_policies is defined and mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
{% for pol in  bd.dhcp_policies | default([]) %}
{% set dhcp_relay_policy_name = pol.dhcp_relay_policy ~ defaults.mso.policies.dhcp_relays.name_suffix %}
    ${dhcp}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].dhcpLabels[?(@.name=='{{ dhcp_relay_policy_name }}')]                     
    Should Be Equal Value Json String   ${r.json()}   ${dhcp}.name   {{ dhcp_relay_policy_name }}
{% if pol.dhcp_option_policy is defined %}
{% set dhcp_option_name = pol.dhcp_option_policy ~ defaults.mso.policies.dhcp_options.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${dhcp}.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endfor %}
{% endif %}


{% for subnet in bd.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.mso.schemas.templates.bridge_domains.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {% if subnet.shared | default(defaults.mso.schemas.templates.bridge_domains.subnets.shared) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.querier   {% if subnet.querier | default(defaults.mso.schemas.templates.bridge_domains.subnets.querier) == "enabled" %}true{% else %}false{% endif %} 
{% if mso.version | default(defaults.mso.version) is version('3.1.1h', '>=') %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {% if subnet.primary | default(defaults.mso.schemas.templates.bridge_domains.subnets.primary) == "enabled" %}true{% else %}false{% endif %} 
{% endif %}
{% endfor %}

{% endfor %}

{% for contract in template.contracts | default([]) %}
{% set contract_name = contract.name ~ defaults.mso.schemas.templates.contracts.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Contract {{ contract_name }}
    ${contract}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].contracts[?(@.name=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${contract}.name   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.displayName   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.scope   {{ contract.scope | default(defaults.mso.schemas.templates.contracts.scope) }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.filterType   {{ contract.type | default(defaults.mso.schemas.templates.contracts.type) }}

{% endfor %}

{% for filter in template.filters | default([]) %}
{% set filter_name = filter.name ~ defaults.mso.schemas.templates.filters.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${filter}.name   {{ filter_name }}
    Should Be Equal Value Json String   ${r.json()}   ${filter}.displayName   {{ filter_name }}

{% for entry in filter.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.mso.schemas.templates.filters.entries.name_suffix %}

{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }} Entry {{ entry_name }}
    ${entry}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')].entries[?(@.name=='{{ entry_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${entry}.description   {{ entry.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.etherType   {{ entry.ethertype | default(defaults.mso.schemas.templates.filters.entries.ethertype) }}
{% if entry.ethertype | default(defaults.mso.schemas.templates.filters.entries.ethertype) in ['ip', 'ipv4', 'ipv6'] %}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.ipProtocol   {{ entry.protocol | default(defaults.mso.schemas.templates.filters.entries.protocol) }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.ipProtocol   unspecified
{% endif %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${entry}.stateful   {% if entry.stateful | default(defaults.mso.schemas.templates.filters.entries.stateful) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   ${entry}.sourceFrom   {{ get_protocol_from_port(entry.source_from_port | default(defaults.mso.schemas.templates.filters.entries.source_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.sourceTo   {{ get_protocol_from_port(entry.source_to_port | default(entry.source_from_port | default(defaults.mso.schemas.templates.filters.entries.source_from_port))) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.destinationFrom   {{ get_protocol_from_port(entry.destination_from_port | default(defaults.mso.schemas.templates.filters.entries.destination_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.destinationTo   {{ get_protocol_from_port(entry.destination_to_port | default(entry.destination_from_port | default(defaults.mso.schemas.templates.filters.entries.destination_from_port))) }}

{% endfor %}

{% endfor %}

{% for epg in template.external_endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.mso.schemas.templates.external_endpoint_groups.name_suffix %}
{% set vrf_name = epg.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.displayName   {{ epg_name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.preferredGroup   {% if epg.preferred_group | default() == "enabled" %}true{% else %}false{% endif %} 
{% if epg.l3out.name is defined %}
{% set l3out_name = epg.l3out.name ~ defaults.mso.schemas.templates.l3outs.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.l3outRef   /schemas/%%schemas%{{ epg.l3out.schema | default(schema.name) }}%%/templates/{{ epg.l3out.template | default(template.name) }}/l3outs/{{ l3out_name }}
{% endif %}
{% if epg.application_profile.name is defined %}
{% set ap_name = epg.application_profile.name ~ defaults.mso.schemas.templates.application_profiles.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.anpRef   /schemas/%%schemas%{{ epg.application_profile.schema | default(schema.name) }}%%/templates/{{ epg.application_profile.template | default(template.name) }}/anps/{{ ap_name }}
{% endif %}

{% for subnet in epg.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }} Subnet {{ subnet.prefix }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.prefix }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.prefix }}

{% endfor %}

{% endfor %}

{% for sg in template.service_graphs | default([]) %}
{% set sg_name = sg.name ~ defaults.mso.schemas.templates.service_graphs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }}
    ${sg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${sg}.name   {{ sg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${sg}.displayName   {{ sg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${sg}.description   {{ sg.description | default() }}

{%- for node in sg.nodes | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }} Node {{ node.name }}
    ${node}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')].serviceNodes[?(@.name=='{{ node.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${node}.name   {{ node.name }}

{% endfor %}

{% endfor %}

{% for l3out in template.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.mso.schemas.templates.l3outs.name_suffix %}
{% set vrf_name = l3out.vrf.name ~ defaults.mso.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} L3out {{ l3out_name }}
    ${l3out}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].intersiteL3outs[?(@.name=='{{ l3out_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${l3out}.name   {{ l3out_name }}
    Should Be Equal Value Json String   ${r.json()}   ${l3out}.displayName   {{ l3out_name }}

{% endfor %}

{% endfor %}

{% endfor %}
