*** Settings ***
Documentation   Verify Schema
Suite Setup     Login NDO
Default Tags    ndo   config   day2
Resource        ../../ndo_common.resource

*** Test Cases ***
{% for schema in ndo.schemas | default([]) %}

Verify Schema {{ schema.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${r}=   GET On Session   ndo   /api/v1/schemas/${schema_id}
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $.displayName   {{ schema.name }}

{% for template in schema.templates | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }}
    ${template}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${template}.name   {{ template.name }}
    Should Be Equal Value Json String   ${r.json()}   ${template}.description   {{ template.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${template}.templateType   {% if template.type | default(defaults.ndo.schemas.templates.type) == "autonomous" %}non-stretched-template{% else %}stretched-template{% endif %}

{% for ap in template.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.ndo.schemas.templates.application_profiles.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }}
    ${ap}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${ap}.name   {{ ap_name }}
    Should Be Equal Value Json String   ${r.json()}   ${ap}.displayName   {{ ap_name }}

{% for epg in ap.endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.displayName   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.description   {{ epg.description | default() }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.uSegEpg   {{ epg.useg | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.useg) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.intraEpg   {% if epg.intra_epg_isolation | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.intra_epg_isolation) | cisco.aac.aac_bool(True) %}enforced{% else %}unenforced{% endif %} 
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.proxyArp   {{ epg.proxy_arp | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.proxy_arp) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.preferredGroup   {{ epg.preferred_group | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.preferred_group) | cisco.aac.aac_bool(True) }}
{% if epg.bridge_domain.name is defined %}
{% set bd_name = epg.bridge_domain.name ~ defaults.ndo.schemas.templates.bridge_domains.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ epg.bridge_domain.schema | default(schema.name) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.bdRef   /schemas/${schema_id}/templates/{{ epg.bridge_domain.template | default(template.name) }}/bds/{{ bd_name }}
{% endif %}
{% if epg.vrf.name is defined %}
{% set vrf_name = epg.vrf.name ~ defaults.ndo.schemas.templates.vrfs.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ epg.vrf.schema | default(schema.name) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.vrfRef   /schemas/${schema_id}/templates/{{ epg.vrf.template | default(template.name) }}/vrfs/{{ vrf_name }}
{% endif %}
{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')].contractRelationships[?(@.relationshipType=='consumer')&(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.relationshipType   consumer
{% endfor %}
{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')].contractRelationships[?(@.relationshipType=='provider')&(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.relationshipType   provider
{% endfor %}

{% for subnet in epg.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].anps[?(@.name=='{{ ap_name }}')].epgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {{ subnet.shared | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.subnets.shared) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.noDefaultGateway   {{ subnet.no_default_gateway | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.subnets.no_default_gateway) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {{ subnet.primary | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.subnets.primary) | cisco.aac.aac_bool(True) }}
{% endfor %}

{% for site in epg.sites | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${epg}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.epgRef   /schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}

{% for pd in site.physical_domains | default([]) %}
{% set domain_name = pd.name ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.physical_domain_name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} Physical Domain {{ domain_name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${pd}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].domainAssociations[?(@.dn=='uni/phys-{{ domain_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pd}.dn   uni/phys-{{ domain_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pd}.domainType   physicalDomain
    Should Be Equal Value Json String   ${r.json()}   ${pd}.deployImmediacy   {{ pd.deployment_immediacy | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.physical_domains.deployment_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}   ${pd}.resolutionImmediacy   {{ pd.resolution_immediacy | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.physical_domains.resolution_immediacy) }}
{% endfor %}

{% for vmm in site.vmware_vmm_domains | default([]) %}
{% set domain_name = vmm.name ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.vmm_domain_name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} VMM Domain {{ domain_name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${vmm}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].domainAssociations[?(@.dn=='uni/vmmp-VMware/dom-{{ domain_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.dn   uni/vmmp-VMware/dom-{{ domain_name }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.domainType   vmmDomain
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.deployImmediacy   {{ vmm.deployment_immediacy | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.deployment_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.resolutionImmediacy   {{ vmm.resolution_immediacy | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.resolution_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.vlanEncapMode   {{ vmm.vlan_mode | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.vlan_mode) }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.switchType   default
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.switchingMode   native
{% if vmm.vlan_mode | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.vlan_mode) == 'static' %}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.portEncapVlan.vlan   {{ vmm.vlan }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.portEncapVlan.vlanType   vlan
{% endif %}
{% if vmm.custom_epg_name is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.customEpgName   {{ vmm.custom_epg_name }}
{% endif %}
{% if vmm.u_segmentation | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.u_segmentation) | cisco.aac.aac_bool(True) %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vmm}.allowMicroSegmentation   True
{% if vmm.vlan_mode | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.vmware_vmm_domains.vlan_mode) == 'static' %}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.microSegVlan.vlan   {{ vmm.useg_vlan }}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.microSegVlan.vlanType   vlan
{% endif %}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${vmm}.allowMicroSegmentation   False
{% endif %}
{% endfor %}

{% for sp in site.static_ports | default([]) %}
{% if sp.type | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.type) == 'port' %}
{% set type = 'port' %}
{% if sp.sub_port is defined %}
{% set path = 'topology/pod-' + sp.pod | default(1) | string + '/paths-' + sp.node | string + '/pathep-[eth' + sp.module | default(1) | string + '/' + sp.port | string + '/' + sp.sub_port | string + ']' %}
{% elif sp.fex is defined %}
{% set path = 'topology/pod-' + sp.pod | default(1) | string + '/paths-' + sp.node | string + '/extpaths-' + sp.fex | string + '/pathep-[eth' + sp.module | default(1) | string + '/' + sp.port | string + ']' %}
{% else %}
{% set path = 'topology/pod-' + sp.pod | default(1) | string + '/paths-' + sp.node | string + '/pathep-[eth' + sp.module | default(1) | string + '/' + sp.port | string + ']' %}
{% endif %}
{% elif sp.type | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.type) == 'pc' %}
{% set type = 'dpc' %}
{% set policy_group_name = sp.channel ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.leaf_interface_policy_group_suffix %}
{% set path = 'topology/pod-' + sp.pod | default(1) | string + '/paths-' + sp.node | string + '/pathep-[' + policy_group_name + ']' %}
{% elif sp.type | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.type) == 'vpc' %}
{% set type = 'vpc' %}
{% set policy_group_name = sp.channel ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.leaf_interface_policy_group_suffix %}
{% set path = 'topology/pod-' + sp.pod | default(1) | string + '/protpaths-' + sp.node_1 | string + '-' + sp.node_2 | string + '/pathep-[' + policy_group_name + ']' %}
{% endif %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} Static Port '{{ path | replace("topology/", "") }}'
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${sp}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].staticPorts[?(@.path=='{{ path }}')]
    Should Be Equal Value Json String   ${r.json()}   ${sp}.type   {{ type }}
    Should Be Equal Value Json String   ${r.json()}   ${sp}.path   {{ path }}
    Should Be Equal Value Json String   ${r.json()}   ${sp}.portEncapVlan   {{ sp.vlan }}
    Should Be Equal Value Json String   ${r.json()}   ${sp}.deploymentImmediacy   {{ sp.deployment_immediacy | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.deployment_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}   ${sp}.mode   {{ sp.mode | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.static_ports.mode) }}
{% if sp.useg_vlan is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${sp}.microSegVlan   {{ sp.useg_vlan }}
{% endif %}
{% endfor %}

{% for sl in site.static_leafs | default([]) %}
{% set path = 'topology/pod-' + sl.pod | default(1) | string + '/node-' + sl.node | string %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} Static Leaf '{{ path | replace("topology/", "") }}'
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${sl}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].staticLeafs[?(@.path=='{{ path }}')]
    Should Be Equal Value Json String   ${r.json()}   ${sl}.path   {{ path }}
    Should Be Equal Value Json String   ${r.json()}   ${sl}.portEncapVlan   {{ sl.vlan }}
{% endfor %}

{% for subnet in site.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} Subnet {{ subnet.ip }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${subnet}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.description   {{ subnet.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {{ subnet.shared | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.subnets.shared) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.noDefaultGateway   {{ subnet.no_default_gateway | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.subnets.no_default_gateway) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {{ subnet.primary | default(defaults.ndo.schemas.templates.application_profiles.endpoint_groups.sites.subnets.primary) | cisco.aac.aac_bool(True) }}
{% endfor %}

{% for selector in site.selectors | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Application Profile {{ ap_name }} Endpoint Group {{ epg_name }} Site {{ site.name }} Selector {{ selector.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${selector}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].selectors[?(@.name=='{{ selector.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${selector}.name   {{ selector.name }}
{% for expression in selector.expressions | default([]) %}
    ${expression}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].anps[?(@.anpRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}')].epgs[?(@.epgRef=='/schemas/${schema_id}/templates/{{ template.name }}/anps/{{ ap_name }}/epgs/{{ epg_name }}')].selectors[?(@.name=='{{ selector.name }}')].expressions[?(@.value=='{{ expression.value }}')]
    Should Be Equal Value Json String   ${r.json()}   ${expression}.key   {{ expression.key }}
    Should Be Equal Value Json String   ${r.json()}   ${expression}.operator   {{ expression.operator }}
    Should Be Equal Value Json String   ${r.json()}   ${expression}.value   {{ expression.value }}
{% endfor %}
{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% for vrf in template.vrfs | default([]) %}
{% set vrf_name = vrf.name ~ defaults.ndo.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} VRF {{ vrf_name }}
    ${vrf}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.name   {{ vrf_name }}
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.displayName   {{ vrf_name }}
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.ipDataPlaneLearning   {{ vrf.data_plane_learning | default(defaults.ndo.schemas.templates.vrfs.data_plane_learning) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.preferredGroup   {{ vrf.preferred_group | default(defaults.ndo.schemas.templates.vrfs.preferred_group) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.l3MCast   {{ vrf.l3_multicast | default(defaults.ndo.schemas.templates.vrfs.l3_multicast) | cisco.aac.aac_bool(True) }}
    {% if vrf.site_aware_policy_enforcement is defined %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.siteAwarePolicyEnforcementMode   {{ vrf.site_aware_policy_enforcement }}
    {% endif %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${vrf}.vzAnyEnabled   {{ vrf.vzany | default(defaults.ndo.schemas.templates.vrfs.vzany) | cisco.aac.aac_bool(True) }}
{% for contract in vrf.contracts.consumers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')].vzAnyConsumerContracts[?(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract_name }}
{% endfor %}
{% for contract in vrf.contracts.providers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].vrfs[?(@.name=='{{ vrf_name }}')].vzAnyProviderContracts[?(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default( template.name ) }}/contracts/{{ contract_name }}
{% endfor %}

{% for site in vrf.sites | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} VRF {{ vrf_name }} Site {{ site.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${vrf}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].vrfs[?(@.vrfRef=='/schemas/${schema_id}/templates/{{ template.name }}/vrfs/{{ vrf_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${vrf}.vrfRef   /schemas/${schema_id}/templates/{{ template.name }}/vrfs/{{ vrf_name }}
{% endfor %}
{% endfor %}

{% for bd in template.bridge_domains | default([]) %}
{% set bd_name = bd.name ~ defaults.ndo.schemas.templates.bridge_domains.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }}
    ${bd}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${bd}.name   {{ bd_name }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.displayName   {{ bd_name }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.description   {{ bd.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.l2UnknownUnicast   {{ bd.l2_unknown_unicast | default(defaults.ndo.schemas.templates.bridge_domains.l2_unknown_unicast)}}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.intersiteBumTrafficAllow   {{ bd.intersite_bum_traffic | default(defaults.ndo.schemas.templates.bridge_domains.intersite_bum_traffic) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.optimizeWanBandwidth   {{ bd.optimize_wan_bandwidth | default(defaults.ndo.schemas.templates.bridge_domains.optimize_wan_bandwidth) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.l2Stretch   {{ bd.l2_stretch | default(defaults.ndo.schemas.templates.bridge_domains.l2_stretch) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.l3MCast   {{ bd.l3_multicast | default(defaults.ndo.schemas.templates.bridge_domains.l3_multicast) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.unicastRouting  {{ bd.unicast_routing | default(defaults.ndo.schemas.templates.bridge_domains.unicast_routing) | cisco.aac.aac_bool(True) }}
{% if bd.virtual_mac is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.vmac   {{ bd.virtual_mac }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.multiDstPktAct   {{ bd.multi_destination_flooding | default(defaults.ndo.schemas.templates.bridge_domains.multi_destination_flooding) }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.unkMcastAct   {{ bd.unknown_ipv4_multicast | default(defaults.ndo.schemas.templates.bridge_domains.unknown_ipv4_multicast) }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.v6unkMcastAct   {{ bd.unknown_ipv6_multicast | default(defaults.ndo.schemas.templates.bridge_domains.unknown_ipv6_multicast) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.arpFlood   {{ bd.arp_flooding | default(defaults.ndo.schemas.templates.bridge_domains.arp_flooding) | cisco.aac.aac_bool(True) }}

{% if bd.dhcp_relay_policy is defined %}
{% set dhcp_relay_policy_name = bd.dhcp_relay_policy ~ defaults.ndo.policies.dhcp_relays.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.dhcpLabel.name   {{ dhcp_relay_policy_name }}
{% if bd.dhcp_option_policy is defined %}
{% set dhcp_option_name = bd.dhcp_option_policy ~ defaults.ndo.policies.dhcp_options.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.dhcpLabel.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endif %}

{% if bd.dhcp_policies is defined %}
{% for pol in  bd.dhcp_policies | default([]) %}
{% set dhcp_relay_policy_name = pol.dhcp_relay_policy ~ defaults.ndo.policies.dhcp_relays.name_suffix %}
    ${dhcp}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].dhcpLabels[?(@.name=='{{ dhcp_relay_policy_name }}')]                     
    Should Be Equal Value Json String   ${r.json()}   ${dhcp}.name   {{ dhcp_relay_policy_name }}
{% if pol.dhcp_option_policy is defined %}
{% set dhcp_option_name = pol.dhcp_option_policy ~ defaults.ndo.policies.dhcp_options.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${dhcp}.dhcpOptionLabel.name   {{ dhcp_option_name }}
{% endif %}
{% endfor %}
{% endif %}


{% for subnet in bd.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].bds[?(@.name=='{{ bd_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.ndo.schemas.templates.bridge_domains.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {{ subnet.shared | default(defaults.ndo.schemas.templates.bridge_domains.subnets.shared) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.noDefaultGateway   {{ subnet.no_default_gateway | default(defaults.ndo.schemas.templates.bridge_domains.subnets.no_default_gateway) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.querier   {{ subnet.querier | default(defaults.ndo.schemas.templates.bridge_domains.subnets.querier) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {{ subnet.primary | default(defaults.ndo.schemas.templates.bridge_domains.subnets.primary) | cisco.aac.aac_bool(True) }}
{% endfor %}

{% for site in bd.sites | default([]) %}
{% set l3outs = site.l3outs | default([]) | map('regex_replace', '$', defaults.ndo.schemas.templates.l3outs.name_suffix) | list %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }} Site {{ site.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${bd}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].bds[?(@.bdRef=='/schemas/${schema_id}/templates/{{ template.name }}/bds/{{ bd_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${bd}.bdRef   /schemas/${schema_id}/templates/{{ template.name }}/bds/{{ bd_name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${bd}.hostBasedRouting   {{ site.advertise_host_routes | default(defaults.ndo.schemas.templates.bridge_domains.sites.advertise_host_routes) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json String   ${r.json()}   ${bd}.mac   {{ site.mac | default(defaults.ndo.schemas.templates.bridge_domains.sites.mac) }}
    ${l3outs}=   Create List   {{ l3outs | join('   ') }}
    Should Be Equal Value Json List   ${r.json()}   ${bd}.l3Outs   ${l3outs}

{% for subnet in site.subnets | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} Bridge Domain {{ bd_name }} Site {{ site.name }} Subnet {{ subnet.ip }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${subnet}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].bds[?(@.bdRef=='/schemas/${schema_id}/templates/{{ template.name }}/bds/{{ bd_name }}')].subnets[?(@.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.scope   {{ subnet.scope | default(defaults.ndo.schemas.templates.bridge_domains.sites.subnets.scope) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.shared   {{ subnet.shared | default(defaults.ndo.schemas.templates.bridge_domains.sites.subnets.shared) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.noDefaultGateway   {{ subnet.no_default_gateway | default(defaults.ndo.schemas.templates.bridge_domains.sites.subnets.no_default_gateway) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.querier   {{ subnet.querier | default(defaults.ndo.schemas.templates.bridge_domains.sites.subnets.querier) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${subnet}.primary   {{ subnet.primary | default(defaults.ndo.schemas.templates.bridge_domains.sites.subnets.primary) | cisco.aac.aac_bool(True) }}
{% endfor %}

{% endfor %}

{% endfor %}

{% for contract in template.contracts | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Contract {{ contract_name }}
    ${contract}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].contracts[?(@.name=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${contract}.name   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.displayName   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.scope   {{ contract.scope | default(defaults.ndo.schemas.templates.contracts.scope) }}
    Should Be Equal Value Json String   ${r.json()}   ${contract}.filterType   {{ contract.type | default(defaults.ndo.schemas.templates.contracts.type) }}

{% endfor %}

{% for filter in template.filters | default([]) %}
{% set filter_name = filter.name ~ defaults.ndo.schemas.templates.filters.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${filter}.name   {{ filter_name }}
    Should Be Equal Value Json String   ${r.json()}   ${filter}.displayName   {{ filter_name }}

{% for entry in filter.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.ndo.schemas.templates.filters.entries.name_suffix %}

{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https",22:"ssh"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}

Verify Schema {{ schema.name }} Template {{ template.name }} Filter {{ filter_name }} Entry {{ entry_name }}
    ${entry}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].filters[?(@.name=='{{ filter_name }}')].entries[?(@.name=='{{ entry_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${entry}.description   {{ entry.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.etherType   {{ entry.ethertype | default(defaults.ndo.schemas.templates.filters.entries.ethertype) }}
{% if entry.ethertype | default(defaults.ndo.schemas.templates.filters.entries.ethertype) in ['ip', 'ipv4', 'ipv6'] %}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.ipProtocol   {{ entry.protocol | default(defaults.ndo.schemas.templates.filters.entries.protocol) }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.ipProtocol   unspecified
{% endif %}
    Should Be Equal Value Json Boolean   ${r.json()}   ${entry}.stateful   {{ entry.stateful | default(defaults.ndo.schemas.templates.filters.entries.stateful) | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.sourceFrom   {{ get_protocol_from_port(entry.source_from_port | default(defaults.ndo.schemas.templates.filters.entries.source_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.sourceTo   {{ get_protocol_from_port(entry.source_to_port | default(entry.source_from_port | default(defaults.ndo.schemas.templates.filters.entries.source_from_port))) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.destinationFrom   {{ get_protocol_from_port(entry.destination_from_port | default(defaults.ndo.schemas.templates.filters.entries.destination_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${entry}.destinationTo   {{ get_protocol_from_port(entry.destination_to_port | default(entry.destination_from_port | default(defaults.ndo.schemas.templates.filters.entries.destination_from_port))) }}

{% endfor %}

{% endfor %}

{% for epg in template.external_endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.ndo.schemas.templates.external_endpoint_groups.name_suffix %}
{% set vrf_name = epg.vrf.name ~ defaults.ndo.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }}
    ${schema_id}=   NDO Lookup   schemas   {{ epg.vrf.schema | default(schema.name) }}
    ${epg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.displayName   {{ epg_name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${epg}.preferredGroup   {{ epg.preferred_group | default() | cisco.aac.aac_bool(True) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.vrfRef    /schemas/${schema_id}/templates/{{ epg.vrf.template | default(template.name) }}/vrfs/{{ vrf_name }}
{% if epg.l3out.name is defined %}
{% set l3out_name = epg.l3out.name ~ defaults.ndo.schemas.templates.l3outs.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ epg.l3out.schema | default(schema.name) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.l3outRef   /schemas/${schema_id}/templates/{{ epg.l3out.template | default(template.name) }}/l3outs/{{ l3out_name }}
{% endif %}
{% if epg.application_profile.name is defined %}
{% set ap_name = epg.application_profile.name ~ defaults.ndo.schemas.templates.application_profiles.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ epg.application_profile.schema | default(schema.name) }}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.anpRef   /schemas/${schema_id}/templates/{{ epg.application_profile.template | default(template.name) }}/anps/{{ ap_name }}
{% for selector in epg.selectors | default([]) %}
{% for ip in selector.ips | default([]) %}
    ${ip}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].selectors[?(@.name=='{{ selector.name }}')].expressions[?(@.value=='{{ ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${ip}.key   ipAddress
    Should Be Equal Value Json String   ${r.json()}   ${ip}.operator   equals
    Should Be Equal Value Json String   ${r.json()}   ${ip}.value   {{ ip }}
{% endfor %}
{% endfor %}
{% endif %}
{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].contractRelationships[?(@.relationshipType=='consumer')&(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.relationshipType   consumer
{% endfor %}
{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract.name ~ defaults.ndo.schemas.templates.contracts.name_suffix %}
    ${schema_id}=   NDO Lookup   schemas   {{ contract.schema | default(schema.name) }}
    ${con}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].contractRelationships[?(@.relationshipType=='provider')&(@.contractRef=='/schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}.contractRef   /schemas/${schema_id}/templates/{{ contract.template | default(template.name) }}/contracts/{{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.relationshipType   provider
{% endfor %}

{% for subnet in epg.subnets | default([]) %}
{% set scope = [] %}
{% if subnet.export_route_control | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.export_route_control) | cisco.aac.aac_bool(True) %}{% set scope = scope + [('export-rtctrl')] %}{% endif %}
{% if subnet.import_route_control | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.import_route_control) | cisco.aac.aac_bool(True) %}{% set scope = scope + [('import-rtctrl')] %}{% endif %}
{% if subnet.import_security | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.import_security) | cisco.aac.aac_bool(True) %}{% set scope = scope + [('import-security')] %}{% endif %}
{% if subnet.shared_route_control | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.shared_route_control) | cisco.aac.aac_bool(True) %}{% set scope = scope + [('shared-rtctrl')] %}{% endif %}
{% if subnet.shared_security | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.shared_security) | cisco.aac.aac_bool(True) %}{% set scope = scope + [('shared-security')] %}{% endif %}
{% set aggregate = [] %}
{% if subnet.aggregate_export | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.aggregate_export) | cisco.aac.aac_bool(True) %}{% set aggregate = aggregate + [('export-rtctrl')] %}{% endif %}
{% if subnet.aggregate_import | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.aggregate_import) | cisco.aac.aac_bool(True) %}{% set aggregate = aggregate + [('import-rtctrl')] %}{% endif %}
{% if subnet.aggregate_shared | default(defaults.ndo.schemas.templates.external_endpoint_groups.subnets.aggregate_shared) | cisco.aac.aac_bool(True) %}{% set aggregate = aggregate + [('shared-rtctrl')] %}{% endif %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }} Subnet {{ subnet.prefix }}
    ${subnet}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].externalEpgs[?(@.name=='{{ epg_name }}')].subnets[?(@.ip=='{{ subnet.prefix }}')]
    ${scope} =   Create List   {{ scope | join('   ') }}
    ${aggregate}=   Create List   {{ aggregate | join('   ') }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}.ip   {{ subnet.prefix }}
    Should Be Equal Value Json List   ${r.json()}   ${subnet}.scope   ${scope}
    Should Be Equal Value Json List   ${r.json()}   ${subnet}.aggregate   ${aggregate}
{% endfor %}

{% for site in epg.sites | default([]) %}

Verify Schema {{ schema.name }} Template {{ template.name }} External EPG {{ epg_name }} Site {{ site.name }}
    ${schema_id}=   NDO Lookup   schemas   {{ schema.name }}
    ${site_id}=   NDO Lookup   sites   {{ site.name }}
    ${epg}=   Set Variable   $.sites[?(@.siteId=='${site_id}')&(@.templateName=='{{ template.name }}')].externalEpgs[?(@.externalEpgRef=='/schemas/${schema_id}/templates/{{ template.name }}/externalEpgs/{{ epg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${epg}.externalEpgRef   /schemas/${schema_id}/templates/{{ template.name }}/externalEpgs/{{ epg_name }}
{% if epg.type | default(defaults.ndo.schemas.templates.external_endpoint_groups.type) == "on-premise" and site.l3out.name is defined %}
{% set l3out_name = site.l3out.name ~ defaults.ndo.schemas.templates.l3outs.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.l3outDn   uni/tn-{{ site.l3out.tenant | default(site.tenant | default(template.tenant)) }}/out-{{ l3out_name }}
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${epg}.l3outDn
{% endif %}

{% endfor %}

{% endfor %}

{% for sg in template.service_graphs | default([]) %}
{% set sg_name = sg.name ~ defaults.ndo.schemas.templates.service_graphs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }}
    ${sg}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${sg}.name   {{ sg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${sg}.displayName   {{ sg_name }}
    Should Be Equal Value Json String   ${r.json()}   ${sg}.description   {{ sg.description | default() }}

{%- for node in sg.nodes | default([]) %}
{% set node_type = {"firewall": "0000ffff0000000000000051", "load-balancer": "0000ffff0000000000000052", "other": "0000ffff0000000000000053"}[node.type | default(defaults.ndo.schemas.templates.service_graphs.node_type)] %}

Verify Schema {{ schema.name }} Template {{ template.name }} Service Graph {{ sg_name }} Node {{ node.name }}
    ${node}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].serviceGraphs[?(@.name=='{{ sg_name }}')].serviceNodes[?(@.name =~ '^{{ node.name }}|node{{ node.index | default(1) }}$')]
    Should Be Equal Value Json String   ${r.json()}   ${node}.name   {{ node.name }}   node{{ node.index | default(1) }}
    Should Be Equal Value Json String   ${r.json()}   ${node}.serviceNodeTypeId   {{ node_type }}
    Should Be Equal Value Json String   ${r.json()}   ${node}.index   {{ node.index | default(1) }}

{% endfor %}

{% endfor %}

{% for l3out in template.l3outs | default([]) %}
{% set l3out_name = l3out.name ~ defaults.ndo.schemas.templates.l3outs.name_suffix %}
{% set vrf_name = l3out.vrf.name ~ defaults.ndo.schemas.templates.vrfs.name_suffix %}

Verify Schema {{ schema.name }} Template {{ template.name }} L3out {{ l3out_name }}
    ${l3out}=   Set Variable   $.templates[?(@.name=='{{ template.name }}')].intersiteL3outs[?(@.name=='{{ l3out_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${l3out}.name   {{ l3out_name }}
    Should Be Equal Value Json String   ${r.json()}   ${l3out}.displayName   {{ l3out_name }}

{% endfor %}

{% endfor %}

{% endfor %}
