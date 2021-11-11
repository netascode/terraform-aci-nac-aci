*** Settings ***
Documentation   Verify VRF
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% macro reserved_entry(value) %}
    {% set reserved_map = {0: "undefined"} %}
    {{ reserved_map[value] | default(value) }}
{% endmacro %}
{% macro max_entry(value) %}
    {% set max_map = {4294967295: "unlimited"} %}
    {{ max_map[value] | default(value) }}
{% endmacro %}
{% macro expiry_entry(value) %}
    {% set expiry_map = {180: "default-timeout"} %}
    {{ expiry_map[value] | default(value) }}
{% endmacro %}

{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for vrf in tenant.vrfs | default([]) %}
{% set vrf_name = vrf.name ~ ('' if vrf.name in ('inb', 'obb', 'overlay-1') else defaults.apic.tenants.vrfs.name_suffix) %}

Verify VRF {{ vrf_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ctx-{{ vrf_name }}.json?rsp-subtree=full"
    String   $..fvCtx.attributes.name   {{ vrf_name }}
    String   $..fvCtx.attributes.nameAlias   {{ vrf.alias | default() }}
    String   $..fvCtx.attributes.descr   {{ vrf.description | default() }}
    String   $..fvCtx.attributes.ipDataPlaneLearning   {{ vrf.data_plane_learning | default(defaults.apic.tenants.vrfs.data_plane_learning) }}
    String   $..fvCtx.attributes.pcEnfDir   {{ vrf.enforcement_direction | default(defaults.apic.tenants.vrfs.enforcement_direction) }}
    String   $..fvCtx.attributes.pcEnfPref   {{ vrf.enforcement_preference | default(defaults.apic.tenants.vrfs.enforcement_preference) }}
    String   $..vzAny.attributes.prefGrMemb   {{ vrf.preferred_group | default(defaults.apic.tenants.vrfs.preferred_group) }}

{% if vrf.bgp.timer_policy is defined %}

Verify BGP Timer Policy {{ vrf.bgp.timer_policy }}
{% set bgp_timer_name = vrf.bgp.timer_policy + defaults.apic.tenants.policies.bgp_timer_policies.name_suffix %}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.fvRsBgpCtxPol.attributes.tnBgpCtxPolName=='{{ bgp_timer_name }}')].fvRsBgpCtxPol
    String   ${bgp_entry}.attributes.tnBgpCtxPolName   {{ bgp_timer_name }}
{% endif %}
 
{% if vrf.bgp.ipv4_address_family_context_policy is defined %}

Verify BGP Address Family Context {{ vrf.bgp.ipv4_address_family_context_policy }}
    {% set address_family_context_policy_name = vrf.bgp.ipv4_address_family_context_policy + defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix %}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.fvRsCtxToBgpCtxAfPol.attributes.tnBgpCtxAfPolName=='{{ address_family_context_policy_name }}')].fvRsCtxToBgpCtxAfPol
    String   ${bgp_entry}.attributes.tnBgpCtxAfPolName   {{ address_family_context_policy_name }}
    String   ${bgp_entry}.attributes.af   ipv4-ucast
{% endif %}

{% if vrf.bgp.ipv6_address_family_context_policy is defined %}

Verify BGP Address Family Context {{ vrf.bgp.ipv6_address_family_context_policy }}
    {% set address_family_context_policy_name = vrf.bgp.ipv6_address_family_context_policy + defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix %}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.fvRsCtxToBgpCtxAfPol.attributes.tnBgpCtxAfPolName=='{{ address_family_context_policy_name }}')].fvRsCtxToBgpCtxAfPol
    String   ${bgp_entry}.attributes.tnBgpCtxAfPolName   {{ address_family_context_policy_name }}
    String   ${bgp_entry}.attributes.af   ipv6-ucast
{% endif %}


{% if vrf.bgp.ipv4_import_route_target is defined %}

Verify BGP IPV4 Import Route Target {{ vrf.bgp.ipv4_import_route_target }}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.bgpRtTargetP.attributes.af=='ipv4-ucast')].bgpRtTargetP.children[?(@.bgpRtTarget.attributes.type=='import')].bgpRtTarget

    String   ${bgp_entry}.attributes.rt   {{ vrf.bgp.ipv4_import_route_target }}
    String   ${bgp_entry}.attributes.type   import
{% endif %}

{% if vrf.bgp.ipv4_export_route_target is defined %}

Verify BGP IPV4 Export Route Target {{ vrf.bgp.ipv4_export_route_target }}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.bgpRtTargetP.attributes.af=='ipv4-ucast')].bgpRtTargetP.children[?(@.bgpRtTarget.attributes.type=='export')].bgpRtTarget

    String   ${bgp_entry}.attributes.rt   {{ vrf.bgp.ipv4_export_route_target }}
    String   ${bgp_entry}.attributes.type   export
{% endif %}

{% if vrf.bgp.ipv6_import_route_target is defined %}

Verify BGP IPV6 Import Route Target {{ vrf.bgp.ipv6_import_route_target }}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.bgpRtTargetP.attributes.af=='ipv6-ucast')].bgpRtTargetP.children[?(@.bgpRtTarget.attributes.type=='import')].bgpRtTarget

    String   ${bgp_entry}.attributes.rt   {{ vrf.bgp.ipv6_import_route_target }}
    String   ${bgp_entry}.attributes.type   import
{% endif %}

{% if vrf.bgp.ipv6_export_route_target is defined %}

Verify BGP IPV6 Export Route Target {{ vrf.bgp.ipv6_export_route_target }}
    ${bgp_entry}=   Set Variable   $..fvCtx.children[?(@.bgpRtTargetP.attributes.af=='ipv6-ucast')].bgpRtTargetP.children[?(@.bgpRtTarget.attributes.type=='export')].bgpRtTarget

    String   ${bgp_entry}.attributes.rt   {{ vrf.bgp.ipv6_export_route_target }}
    String   ${bgp_entry}.attributes.type   export
{% endif %}

{% for contract in vrf.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}
Verify VRF {{ vrf.name }} vzAny Contract Provider {{ contract_name }}
    ${vzany_prov}=   Set Variable   $..vzAny.children[?(@.vzRsAnyToProv.attributes.tnVzBrCPName=='{{ contract_name }}')].vzRsAnyToProv
    String   ${vzany_prov}.attributes.tnVzBrCPName   {{ contract_name }}
{% endfor %}

{% for contract in vrf.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify VRF {{ vrf.name }} vzAny Contract consumers {{ contract_name }}
    ${vzany_cons}=   Set Variable   $..vzAny.children[?(@.vzRsAnyToCons.attributes.tnVzBrCPName=='{{ contract_name }}')].vzRsAnyToCons
    String   ${vzany_cons}.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in vrf.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify VRF {{ vrf.name }} vzAny Contract Import consumers {{ contract_name }}
    ${vzany_consIf}=   Set Variable   $..vzAny.children[?(@.vzRsAnyToConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')].vzRsAnyToConsIf
    String   ${vzany_consIf}.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}
{% if vrf.pim is defined %}

Verify VRF {{ vrf.name }} PIM
    String   $..fvCtx.children..pimCtxP.attributes.mtu   {{ vrf.pim.mtu | default(defaults.apic.tenants.vrfs.pim.mtu)}}
    String   $..fvCtx.children..pimCtxP.children..pimResPol.attributes.max   {{ max_entry(vrf.pim.max_multicast_entries | default(defaults.apic.tenants.vrfs.pim.max_multicast_entries)) }}
    String   $..fvCtx.children..pimCtxP.children..pimResPol.attributes.rsvd   {{ reserved_entry(vrf.pim.reserved_multicast_entries | default(defaults.apic.tenants.vrfs.pim.reserved_multicast_entries)) }}
{% if vrf.pim.resource_policy_multicast_route_map is defined %}
{% set resource_policy_multicast_route_map_name = vrf.pim.resource_policy_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..fvCtx.children..pimCtxP.children..pimResPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ resource_policy_multicast_route_map_name }}
{% endif %}

{% set ctrl = [] %}
{% if vrf.pim.bsr_forward_updates | default(defaults.apic.tenants.vrfs.pim.bsr_forward_updates) == "yes" %}{% set ctrl = ctrl + [("forward")] %}{% endif %}
{% if vrf.pim.bsr_listen_updates | default(defaults.apic.tenants.vrfs.pim.bsr_listen_updates) == "yes" %}{% set ctrl = ctrl + [("listen")] %}{% endif %}

Verify VRF {{ vrf.name }} PIM BSR
    String   $..fvCtx.children..pimCtxP.children..pimBSRPPol.attributes.ctrl   {{ ctrl | join(',') }}
{% if vrf.pim.bsr_filter_multicast_route_map is defined %}
{% set bsr_filter_name = vrf.pim.bsr_filter_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..fvCtx.children..pimCtxP.children..pimBSRPPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ bsr_filter_name }}

{% endif %}
{% set ctrl = [] %}
{% if vrf.pim.auto_rp_forward_updates | default(defaults.apic.tenants.vrfs.pim.auto_rp_forward_updates) == "yes" %}{% set ctrl = ctrl + [("forward")] %}{% endif %}
{% if vrf.pim.auto_rp_listen_updates | default(defaults.apic.tenants.vrfs.pim.auto_rp_listen_updates) == "yes" %}{% set ctrl = ctrl + [("listen")] %}{% endif %}

Verify VRF {{ vrf.name }} PIM Auto-RP
    String   $..fvCtx.children..pimCtxP.children..pimAutoRPPol.attributes.ctrl   {{ ctrl | join(',') }}
{% if vrf.pim.auto_rp_filter_multicast_route_map is defined %}
{% set auto_rp_filter_name = vrf.pim.auto_rp_filter_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   $..fvCtx.children..pimCtxP.children..pimAutoRPPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ auto_rp_filter_name }}

{% endif %}

{% if vrf.pim.static_rps is defined %}
{% for static_rp in vrf.pim.static_rps %}

Verify VRF {{ vrf.name }} PIM Static RP {{ static_rp.ip }}
    ${rp}=   Set Variable   $..fvCtx.children..pimCtxP.children..pimStaticRPPol.children[?(@.pimStaticRPEntryPol.attributes.rpIp=='{{ static_rp.ip }}')].pimStaticRPEntryPol
    String   ${rp}.attributes.rpIp   {{ static_rp.ip }}

{% if static_rp.multicast_route_map is defined %}
{% set static_rp_route_map_name = static_rp.multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   ${rp}.children..pimRPGrpRangePol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ static_rp_route_map_name }}

{% endif %}

{% endfor %}
{% endif %}

{% if vrf.pim.fabric_rps is defined %}
{% for fabric_rp in vrf.pim.fabric_rps %}

Verify VRF {{ vrf.name }} PIM Fabric RP {{ fabric_rp.ip }}
    ${rp}=   Set Variable   $..fvCtx.children..pimCtxP.children..pimFabricRPPol.children[?(@.pimStaticRPEntryPol.attributes.rpIp=='{{ fabric_rp.ip }}')].pimStaticRPEntryPol
    String   ${rp}.attributes.rpIp   {{ fabric_rp.ip }}

{% if fabric_rp.multicast_route_map is defined %}

{% set fabric_rp_route_map_name = fabric_rp.multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   ${rp}.children..pimRPGrpRangePol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ fabric_rp_route_map_name }}

{% endif %}

{% endfor %}
{% endif %}

Verify VRF {{ vrf.name }} PIM ASM Pattern Policy
{% if vrf.pim.asm_shared_range_multicast_route_map is defined %}
{% set asm_shared_range_multicast_route_map_name = vrf.pim.asm_shared_range_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String  $..fvCtx.children..pimCtxP.children..pimASMPatPol.children..pimSharedRangePol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ asm_shared_range_multicast_route_map_name }}
{% endif %}
{% if vrf.pim.asm_sg_expiry_multicast_route_map is defined %}
{% set asm_sg_expiry_multicast_route_map_name = vrf.pim.asm_sg_expiry_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String  $..fvCtx.children..pimCtxP.children..pimASMPatPol.children..pimSGRangeExpPol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ asm_sg_expiry_multicast_route_map_name }}
{% endif %}
    String  $..fvCtx.children..pimCtxP.children..pimASMPatPol.children..pimRegTrPol.attributes.maxRate   {{ vrf.pim.asm_traffic_registry_max_rate | default(defaults.apic.tenants.vrfs.pim.asm_traffic_registry_max_rate) }}
    String  $..fvCtx.children..pimCtxP.children..pimASMPatPol.children..pimRegTrPol.attributes.srcIp   {{ vrf.pim.asm_traffic_registry_source_ip | default(defaults.apic.tenants.vrfs.pim.asm_traffic_registry_source_ip) }}

{% if vrf.pim.ssm_group_range_multicast_route_map is defined %}
Verify VRF {{ vrf.name }} PIM SSM Pattern Policy
{% set ssm_group_range_multicast_route_map_name = vrf.pim.ssm_group_range_multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String  $..fvCtx.children..pimCtxP.children..pimSSMPatPol.children..pimSSMRangePol.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ ssm_group_range_multicast_route_map_name }}
{% endif %}

{% if vrf.pim.inter_vrf_policies is defined %}
{% for pol in vrf.pim.inter_vrf_policies | default([]) %}
{% set vrf_name = pol.vrf ~ defaults.apic.tenants.vrfs.name_suffix %}
Verify VRF {{ vrf.name }} Inter-VRF Multicast Tenant {{ pol.tenant}} VRF {{ vrf_name }}
     ${inter_vrf}=   Set Variable   $..fvCtx.children..pimCtxP.children..pimInterVRFPol.children[?(@.pimInterVRFEntryPol.attributes.srcVrfDn=='uni/tn-{{ pol.tenant }}/ctx-{{ vrf_name }}')].pimInterVRFEntryPol
    String   ${inter_vrf}.attributes.srcVrfDn   uni/tn-{{ pol.tenant }}/ctx-{{ vrf_name }}
{% if pol.multicast_route_map is defined %}
{% set multicast_route_map_name = pol.multicast_route_map ~ defaults.apic.tenants.policies.multicast_route_maps.name_suffix %}
    String   ${inter_vrf}.children..rtdmcRsFilterToRtMapPol.attributes.tDn   uni/tn-{{ tenant.name }}/rtmap-{{ multicast_route_map_name}}
{% endif %}

{% endfor %}

{% endif %}

{% endif %}

{% if vrf.pim.igmp_context_ssm_translate_policies is defined %}
{% for pol in vrf.pim.igmp_ssm_translate_policies | default([]) %}
Verify VRF {{ vrf.name }} IGMP Context SSM Tranlation policies {{ pol.group_prefix }}-{{ pol.source_address }}
    ${igmp_ssn}=   Set Variable   $..fvCtx.children..igmpCtxP.children[?(@.igmpSSMXlateP.attributes.descr=='{{ pol.group_prefix }}-{{ pol.source_address }}')].igmpSSMXlateP
    String   ${igmp_ssn}.attributes.grpPfx   {{ pol.group_prefix }}
    String   ${igmp_ssn}.attributes.srcAddr   {{ pol.source_address }}

{% endfor %}

{% endif %}

{% endfor %}
