*** Settings ***
Documentation   Verify Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{%- macro get_nlb_mode(name) -%}
    {%- set modes = {"mode-mcast-static":"mode-mcast--static"} -%}
    {{ modes[name] | default(name)}}
{%- endmacro -%}

{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% for epg in ap.endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix %}
{% set bd_name = epg.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix %}

Verify Endpoint Group {{ epg_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/epg-{{ epg_name }}.json?rsp-subtree=full"
    String   $..fvAEPg.attributes.name   {{ epg_name }}
    String   $..fvAEPg.attributes.descr   {{ epg.description | default() }}
    String   $..fvAEPg.attributes.nameAlias   {{ epg.alias | default() }}
    String   $..fvAEPg.attributes.floodOnEncap   {{ epg.flood_in_encap | default(defaults.apic.tenants.application_profiles.endpoint_groups.flood_in_encap) }}
    String   $..fvAEPg.attributes.pcEnfPref   {{ epg.intra_epg_isolation | default(defaults.apic.tenants.application_profiles.endpoint_groups.intra_epg_isolation) }}
    String   $..fvAEPg.attributes.prefGrMemb   {{ epg.preferred_group | default(defaults.apic.tenants.application_profiles.endpoint_groups.preferred_group) }}
    String   $..fvRsBd.attributes.tnFvBDName   {{ bd_name }}
    String   $..fvAEPg.attributes.prio   {{ epg.qos_class | default(defaults.apic.tenants.application_profiles.endpoint_groups.qos_class) }}

{% for vmm in epg.vmware_vmm_domains | default([]) %}
{% set vmm_name = vmm.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.name_suffix %}

Verify Endpoint Group {{ epg_name }} VMM Domain {{ vmm_name }}
    ${conn}=   Set Variable   $..fvAEPg.children[?(@.fvRsDomAtt.attributes.tDn=='uni/vmmp-VMware/dom-{{ vmm_name }}')].fvRsDomAtt
{% if vmm.u_segmentation | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.u_segmentation) == 'yes' %}{% set useg = 'useg' %}{% else %}{% set useg = 'encap' %}{% endif %}
    String   ${conn}.attributes.classPref   {{ useg }}
    String   ${conn}.attributes.delimiter   \{{ vmm.delimiter | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.delimiter) }}
{% if vmm.primary_vlan is defined %}
    String   ${conn}.attributes.encap   vlan-{{ vmm.secondary_vlan }}
{% elif vmm.vlan is defined %}
    String   ${conn}.attributes.encap   vlan-{{ vmm.vlan }}
{% else %}
    String   ${conn}.attributes.encap   unknown
{% endif %}
    String   ${conn}.attributes.encapMode   auto
    String   ${conn}.attributes.instrImedcy   {{ vmm.deployment_immediacy  | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.deployment_immediacy) }}
    String   ${conn}.attributes.netflowPref   {{ vmm.netflow | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.netflow) }}
{% if vmm.primary_vlan is defined %}
    String   ${conn}.attributes.primaryEncap   vlan-{{ vmm.primary_vlan }}
{% else %}
    String   ${conn}.attributes.primaryEncap   unknown
{% endif %}
    String   ${conn}.attributes.resImedcy   {{ vmm.resolution_immediacy | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.resolution_immediacy) }}
    String   ${conn}.attributes.switchingMode   native
    
    String   ${conn}.children..vmmSecP.attributes.allowPromiscuous   {{ vmm.allow_promiscuous | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.allow_promiscuous) }}
    String   ${conn}.children..vmmSecP.attributes.forgedTransmits   {{ vmm.forged_transmits | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.forged_transmits) }}
    String   ${conn}.children..vmmSecP.attributes.macChanges   {{ vmm.mac_changes | default(defaults.apic.tenants.application_profiles.endpoint_groups.vmware_vmm_domains.mac_changes) }}
{% if vmm.active_uplinks_order is defined or vmm.standby_uplinks is defined %}
    String   ${conn}.children..fvUplinkOrderCont.attributes.active   {{ vmm.active_uplinks_order | default() }}
    String   ${conn}.children..fvUplinkOrderCont.attributes.standby   {{ vmm.standby_uplinks | default() }}
{% endif %}
{% if vmm.elag is defined %}
    String   ${conn}.children..fvAEPgLagPolAtt.children..fvRsVmmVSwitchEnhancedLagPol.attributes.tDn   uni/vmmp-VMware/dom-{{ vmm_name }}/vswitchpolcont/enlacplagp-{{ vmm.elag }}
{% endif %}
{% endfor %}

{% for st_ep in epg.static_endpoints | default([]) %}
{% set static_endpoint_name = st_ep.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.static_endpoints.name_suffix %}

Verify Endpoint Group {{ epg_name }} Static Endpoint {{ st_ep.name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvStCEp.attributes.name=='{{ static_endpoint_name }}')].fvStCEp
    {% if st_ep.type != "vep" %}
    String   ${con}.attributes.encap   vlan-{{ st_ep.vlan }}
    {% else %}
    String   ${con}.attributes.encap   unknown
    {% endif %}
    String   ${con}.attributes.ip   {{ st_ep.ip | default(defaults.apic.tenants.application_profiles.endpoint_groups.static_endpoints.ip)}}
    String   ${con}.attributes.mac   {{ st_ep.mac }}
    String   ${con}.attributes.name   {{ static_endpoint_name }}
    String   ${con}.attributes.nameAlias   {{ st_ep.alias | default() }}
    String   ${con}.attributes.type   {{ st_ep.type }}
    {% if st_ep.type != "vep" %}
    {% if st_ep.node_id is defined and st_ep.channel is not defined %}
    {% set query = "nodes[?id==`" ~ st_ep.node_id ~ "`].pod" %}
    {% set pod = st_ep.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    String   ${con}.children..fvRsStCEpToPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ st_ep.node_id }}/pathep-[eth{{ st_ep.module | default(defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.module) }}/{{ st_ep.port }}]
    {% else %}
    {% set policy_group_name = st_ep.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
    {% set query = "leaf_interface_policy_groups[?name==`" ~ st_ep.channel ~ "`].type" %}
    {% set type = (apic.access_policies | json_query(query))[0] %}
    {% if st_ep.node_id is defined %}
    {% set node = st_ep.node_id %}
    {% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ st_ep.channel ~ "`]].id" %}
    {% set node = (apic.interface_policies | json_query(query))[0] %}
    {% endif %}
    {% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
    {% set pod = st_ep.pod_id | default(((apic.node_policies | default()) | json_query(query))[0] | default('1')) %}
    {% if type == 'vpc' %}
    {% if st_ep.node2_id is defined %}
    {% set node2 = st_ep.node2_id %}
    {% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ st_ep.channel ~ "`]].id" %}
    {% set node2 = (apic.interface_policies | json_query(query))[1] %}
    {% endif %}
    String   ${con}.children..fvRsStCEpToPathEp.attributes.tDn   topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]
    {% else %}
    String   ${con}.children..fvRsStCEpToPathEp.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
    {% endif %}
    {% endif %}
    {% endif %}
{% for ip in st_ep.additional_ips | default([]) %}
    ${ip}=   Set Variable   ${con}.children[?(@.fvStIp.attributes.addr=='{{ ip }}')].fvStIp
    String   ${ip}.attributes.addr   {{ ip }}    
{% endfor %}
{% endfor %}

{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Group {{ epg_name }} Contract Provider {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsProv.attributes.tnVzBrCPName=='{{ contract_name }}')]
    String   ${con}..fvRsProv.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Group {{ epg_name }} Contract consumers {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsCons.attributes.tnVzBrCPName=='{{ contract_name }}')]
    String   ${con}..fvRsCons.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Endpoint Group {{ epg_name }} Imported Contract {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')]
    String   ${con}..fvRsConsIf.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}

{% for pd in epg.physical_domains | default([]) %}
{% set domain_name = pd ~ defaults.apic.access_policies.physical_domains.name_suffix %}

Verify Endpoint Group {{ epg_name }} Physical Domain {{ domain_name }}
    ${conn}=   Set Variable   $..fvAEPg.children[?(@.fvRsDomAtt.attributes.tDn=='uni/phys-{{ domain_name }}')].fvRsDomAtt
    String   ${conn}.attributes.tDn   uni/phys-{{ domain_name }}

{% endfor %}

{% for subnet in epg.subnets | default([]) %}
{% set scope = [] %}
{% if subnet.private | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.private) == "yes" %}{% set scope = scope + [("private")] %}{% endif %}
{% if subnet.public | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.public) == "yes" %}{% set scope = scope + [("public")] %}{% endif %}
{% if subnet.shared | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.shared) == "yes" %}{% set scope = scope + [("shared")] %}{% endif %}
{% set ctrl = [] %}
{% if subnet.nd_ra_prefix | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.nd_ra_prefix) == "yes" %}{% set ctrl = ctrl + [("nd")] %}{% endif %}
{% if subnet.no_default_gateway | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.no_default_gateway) == "yes" %}{% set ctrl = ctrl + [("no-default-gateway")] %}{% endif %}
{% if subnet.igmp_querier | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.igmp_querier) == "yes" %}{% set ctrl = ctrl + [("querier")] %}{% endif %}
Verify Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $..fvAEPg.children[?(@.fvSubnet.attributes.ip=='{{ subnet.ip }}')]
    String   ${subnet}..fvSubnet.attributes.ip   {{ subnet.ip }}
    String   ${subnet}..fvSubnet.attributes.ctrl   {{ ctrl | join(',') }}
    String   ${subnet}..fvSubnet.attributes.descr   {{ subnet.description | default() }}
    String   ${subnet}..fvSubnet.attributes.preferred   {{ subnet.primary_ip | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.primary_ip) }}
    String   ${subnet}..fvSubnet.attributes.scope   {{ scope | join(',') }}
    String   ${subnet}..fvSubnet.attributes.virtual   {{ subnet.virtual | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.virtual) }}           
{% if subnet.next_hop_ip is defined %}
    String   ${subnet}..ipNexthopEpP.attributes.nhAddr   {{ subnet.next_hop_ip }} 
{% elif subnet.anycast_mac is defined %}
    String   ${subnet}..fvEpAnycast.attributes.mac   {{ subnet.anycast_mac }} 
{% elif subnet.nlb_mode is defined %}
    String   ${subnet}..fvEpNlb.attributes.group   {{ subnet.nlb_group | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.nlb_group) }}
    String   ${subnet}..fvEpNlb.attributes.mac   {{ subnet.nlb_mac | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.nlb_mac) }}
    String   ${subnet}..fvEpNlb.attributes.mode   {{ get_nlb_mode(subnet.nlb_mode) }}
{% endif %}

{% for pool in subnet.ip_pools | default([]) %}
{% set pool_name = pool.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.subnets.ip_pools.name_suffix %}
Verify Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }} IP Address Pool {{ pool_name }}
    ${subnet}=   Set Variable   $..fvAEPg.children[?(@.fvSubnet.attributes.ip=='{{ subnet.ip }}')].fvSubnet
    ${pool}=   Set Variable   ${subnet}.children[?(@.fvCepNetCfgPol.attributes.name=='{{ pool_name }}')]
    String   ${pool}..fvCepNetCfgPol.attributes.name   {{ pool_name }}
    String   ${pool}..fvCepNetCfgPol.attributes.startIp   {{ pool.start_ip | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.ip_pools.start_ip) }}
    String   ${pool}..fvCepNetCfgPol.attributes.endIp   {{ pool.end_ip | default(defaults.apic.tenants.application_profiles.endpoint_groups.subnets.ip_pools.end_ip) }}
    String   ${pool}..fvCepNetCfgPol.attributes.dnsSearchSuffix   {{ pool.dns_search_suffix | default() }}
    String   ${pool}..fvCepNetCfgPol.attributes.dnsServers   {{ pool.dns_server | default() }}
    String   ${pool}..fvCepNetCfgPol.attributes.dnsSuffix   {{ pool.dns_suffix | default() }}
    String   ${pool}..fvCepNetCfgPol.attributes.winsServers   {{ pool.wins_server | default() }}

{% endfor %}

{% endfor %}

{% if epg.custom_qos_policy is defined %}
{% set custom_qos_policy_name = epg.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
Verify Endpoint Group {{ epg_name }} Custom QoS Policy
    String   $..fvRsCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

{% if epg.tags is defined %}
Verify Endpoint Group {{ epg_name }} Tags
{% for tag in epg.tags | default([]) %}

    ${tag}=   Set Variable   $..fvAEPg.children[?(@.tagInst.attributes.name=='{{ tag }}')]
    String   ${tag}..attributes.name   {{ tag }}

{% endfor %}

{% endif %}

{% for vip in epg.l4l7_virtual_ips | default([]) %}
Verify Endpoint Group {{ epg_name }} L4-L7 Virtual IP {{ vip.ip }}
    ${vip}=   Set Variable   $..fvAEPg.children[?(@.fvVip.attributes.addr=='{{ vip.ip }}')].fvVip    
    String   ${vip}.attributes.addr   {{ vip.ip }}
    String   ${vip}.attributes.descr   {{ vip. description | default() }}
                      
{% endfor %}

{% for pool in epg.l4l7_address_pools | default([]) %}
Verify Endpoint Group {{ epg_name }} L4-L7 IP Address Pool {{ pool.name }}
    ${pool}=   Set Variable   $..fvAEPg.children[?(@.vnsAddrInst.attributes.name=='{{ pool.name }}')].vnsAddrInst    
    String   ${pool}.attributes.name   {{ pool.name }}
    String   ${pool}.attributes.addr   {{ pool.gateway_address }}
{% if pool.from is defined and pool.to is defined %}
    String   ${pool}..fvnsUcastAddrBlk.attributes.from   {{ pool.from }}
    String   ${pool}..fvnsUcastAddrBlk.attributes.to   {{ pool.to }}
{% endif %}

{% endfor %}  

{% if epg.trust_control_policy is defined %}
{% set trust_control_policy_name = epg.trust_control_policy ~ defaults.apic.tenants.policies.trust_control_policies.name_suffix %}
Verify Endpoint Group {{ epg_name }} Trust Control Policy {{ trust_control_policy_name }}
    String   $..fvRsTrustCtrl.attributes.tnFhsTrustCtrlPolName   {{ trust_control_policy_name }}
{% endif %}

{% endfor %}

{% endfor %}
