{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify uSeg Endpoint Group
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{%- macro get_nlb_mode(name) -%}
    {%- set modes = {"mode-mcast-static":"mode-mcast--static"} -%}
    {{ modes[name] | default(name)}}
{%- endmacro -%}

{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ap in tenant.application_profiles | default([]) %}
{% set ap_name = ap.name ~ defaults.apic.tenants.application_profiles.name_suffix %}
{% for epg in ap.useg_endpoint_groups | default([]) %}
{% set epg_name = epg.name ~ defaults.apic.tenants.application_profiles.useg_endpoint_groups.name_suffix %}
{% set bd_name = epg.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ap-{{ ap_name }}/epg-{{ epg_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.name   {{ epg_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.descr   {{ epg.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.nameAlias   {{ epg.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.floodOnEncap   {{ 'enabled' if epg.flood_in_encap | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.flood_in_encap) else 'disabled' }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.pcEnfPref   {{ 'enforced' if epg.intra_epg_isolation | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.intra_epg_isolation) else 'unenforced' }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.prefGrMemb   {{ 'include' if epg.preferred_group | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.preferred_group) else 'exclude' }}
    Should Be Equal Value Json String   ${r.json()}   $..fvRsBd.attributes.tnFvBDName   {{ bd_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.prio   {{ epg.qos_class | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.qos_class) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.attributes.isAttrBasedEPg   yes

{% for vmm in epg.vmware_vmm_domains | default([]) %}
{% set vmm_name = vmm.name ~ defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }} VMM Domain {{ vmm_name }}
    ${conn}=   Set Variable   $..fvAEPg.children[?(@.fvRsDomAtt.attributes.tDn=='uni/vmmp-VMware/dom-{{ vmm_name }}')].fvRsDomAtt
 
    Should Be Equal Value Json String   ${r.json()}   ${conn}.attributes.instrImedcy   {{ vmm.deployment_immediacy  | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.deployment_immediacy) }}
    Should Be Equal Value Json String   ${r.json()}   ${conn}.attributes.netflowPref   {{ 'enabled' if vmm.netflow | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.vmware_vmm_domains.netflow) else 'disabled' }}
{% if vmm.active_uplinks_order is defined or vmm.standby_uplinks is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${conn}.children..fvUplinkOrderCont.attributes.active   {{ vmm.active_uplinks_order | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${conn}.children..fvUplinkOrderCont.attributes.standby   {{ vmm.standby_uplinks | default() }}
{% endif %}
{% if vmm.elag is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${conn}.children..fvAEPgLagPolAtt.children..fvRsVmmVSwitchEnhancedLagPol.attributes.tDn   uni/vmmp-VMware/dom-{{ vmm_name }}/vswitchpolcont/enlacplagp-{{ vmm.elag }}
{% endif %}
{% endfor %}

{% for sl in epg.static_leafs | default([]) %}
{% set query = "nodes[?id==`" ~ sl.node_id ~ "`].pod" %}
{% set pod = sl.pod_id | default(((apic.node_policies | default()) | community.general.json_query(query))[0] | default('1')) %}

Verify uSeg Endpoint Group {{ epg_name }} Static Leaf {{ sl.node_id }}
    ${sl}=   Set Variable   $..fvAEPg.children[?(@.fvRsNodeAtt.attributes.tDn=='topology/pod-{{ pod }}/node-{{ sl.node_id }}')].fvRsNodeAtt
    Should Be Equal Value Json String   ${r.json()}   ${sl}.attributes.instrImedcy   immediate
    Should Be Equal Value Json String   ${r.json()}   ${sl}.attributes.tDn   topology/pod-{{ pod }}/node-{{ sl.node_id }}

{% endfor %}

{% for master in epg.contracts.masters | default([]) %}
    {% set app_profile_name = (master.application_profile | default(ap_name)) %}
Verify EPG Contract Master 'uni/tn-{{ tenant.name }}/ap-{{ app_profile_name }}/epg-{{ master.endpoint_group }}'
    ${con_master}=   Set Variable   $..fvAEPg.children[?(@.fvRsSecInherited.attributes.tDn=='uni/tn-{{ tenant.name }}/ap-{{ app_profile_name }}/epg-{{ master.endpoint_group }}')]
    Should Not Be Empty   ${con_master}..fvRsSecInherited.attributes.tDn
{% endfor %}

{% for contract in epg.contracts.providers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }} Contract Provider {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsProv.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsProv.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }} Contract Consumers {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsCons.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsCons.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.imported_consumers | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.imported_contracts.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }} Imported Contract {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsConsIf.attributes.tnVzCPIfName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsConsIf.attributes.tnVzCPIfName   {{ contract_name }}

{% endfor %}

{% for contract in epg.contracts.intra_epgs | default([]) %}
{% set contract_name = contract ~ defaults.apic.tenants.contracts.name_suffix %}

Verify uSeg Endpoint Group {{ epg_name }} Intra-EPG Contract {{ contract_name }}
    ${con}=   Set Variable   $..fvAEPg.children[?(@.fvRsIntraEpg.attributes.tnVzBrCPName=='{{ contract_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${con}..fvRsIntraEpg.attributes.tnVzBrCPName   {{ contract_name }}

{% endfor %}

{% for pd in epg.physical_domains | default([]) %}
{% set domain_name = pd ~ defaults.apic.access_policies.physical_domains.name_suffix %}

Verify Endpoint Group {{ epg_name }} Physical Domain {{ domain_name }}
    ${conn}=   Set Variable   $..fvAEPg.children[?(@.fvRsDomAtt.attributes.tDn=='uni/phys-{{ domain_name }}')].fvRsDomAtt
    Should Be Equal Value Json String   ${r.json()}   ${conn}.attributes.tDn   uni/phys-{{ domain_name }}

{% endfor %}

Verify uSeg Endpoint Group {{ epg_name }} uSeg Attributes
    Should Be Equal Value Json String   ${r.json()}   $..fvAEPg.children..fvCrtrn.attributes.match   {{ epg.useg_attributes.match_type | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.match_type) }}

{% for ip_statement in epg.useg_attributes.ip_statements | default([]) %}
Verify uSeg Endpoint Group {{ epg_name }} uSeg Attributes IP Statement {{ ip_statement.name }}
    ${statement}=   Set Variable   $..fvAEPg.children..fvCrtrn.children[?(@.fvIpAttr.attributes.name=='{{ ip_statement.name }}')].fvIpAttr
    Should Be Equal Value Json String   ${r.json()}   ${statement}.attributes.name   {{ ip_statement.name }}
    Should Be Equal Value Json String   ${r.json()}   ${statement}.attributes.usefvSubnet   {{ 'yes' if ip_statement.use_epg_subnet | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.ip_statements.use_epg_subnet) else 'no' }}
    Should Be Equal Value Json String   ${r.json()}   ${statement}.attributes.ip   {{ '0.0.0.0' if ip_statement.use_epg_subnet | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.useg_attributes.ip_statements.use_epg_subnet) else ip_statement.ip }}
 
{% endfor %}

{% for mac_statement in epg.useg_attributes.mac_statements | default([]) %}
Verify uSeg Endpoint Group {{ epg_name }} uSeg Attributes MAC Statement {{ mac_statement.name }}
    ${statement}=   Set Variable   $..fvAEPg.children..fvCrtrn.children[?(@.fvMacAttr.attributes.name=='{{ mac_statement.name }}')].fvMacAttr
    Should Be Equal Value Json String   ${r.json()}   ${statement}.attributes.name   {{ mac_statement.name }}
    Should Be Equal Value Json String   ${r.json()}   ${statement}.attributes.mac   {{ mac_statement.mac | upper }}

{% endfor %}

{% for subnet in epg.subnets | default([]) %}
{% set scope = [] %}
{% if subnet.public | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.public) %}{% set scope = scope + [("public")] %}{% else %}{% set scope = scope + [("private")] %}{% endif %}
{% if subnet.shared | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.shared) %}{% set scope = scope + [("shared")] %}{% endif %}
{% set ctrl = [] %}
{% if subnet.nd_ra_prefix | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.nd_ra_prefix) %}{% set ctrl = ctrl + [("nd")] %}{% endif %}
{% if subnet.no_default_gateway | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.no_default_gateway) %}{% set ctrl = ctrl + [("no-default-gateway")] %}{% endif %}
{% if subnet.igmp_querier | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.igmp_querier) %}{% set ctrl = ctrl + [("querier")] %}{% endif %}
Verify uSeg Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }}
    ${subnet}=   Set Variable   $..fvAEPg.children[?(@.fvSubnet.attributes.ip=='{{ subnet.ip }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.ip   {{ subnet.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.ctrl   {{ ctrl | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.descr   {{ subnet.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.scope   {{ scope | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.attributes.virtual   {{ 'yes' if subnet.virtual | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.virtual) else 'no' }}
{% if subnet.next_hop_ip is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..ipNexthopEpP.attributes.nhAddr   {{ subnet.next_hop_ip }} 
{% elif subnet.anycast_mac is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvEpAnycast.attributes.mac   {{ subnet.anycast_mac }} 
{% elif subnet.nlb_mode is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvEpNlb.attributes.group   {{ subnet.nlb_group | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.nlb_group) }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvEpNlb.attributes.mac   {{ subnet.nlb_mac | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.nlb_mac) }}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvEpNlb.attributes.mode   {{ get_nlb_mode(subnet.nlb_mode) }}
{% endif %}
{% if subnet.nd_ra_prefix_policy is defined %}
{% set nd_ra_prefix_policy_name = subnet.nd_ra_prefix_policy ~ defaults.apic.tenants.policies.nd_ra_prefix_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${subnet}..fvSubnet.children..fvRsNdPfxPol.attributes.tnNdPfxPolName   {{ nd_ra_prefix_policy_name }}
{% endif %}

{% for pool in subnet.ip_pools | default([]) %}
{% set pool_name = pool.name ~ defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.ip_pools.name_suffix %}
Verify uSeg Endpoint Group {{ epg_name }} Subnet {{ subnet.ip }} IP Address Pool {{ pool_name }}
    ${subnet}=   Set Variable   $..fvAEPg.children[?(@.fvSubnet.attributes.ip=='{{ subnet.ip }}')].fvSubnet
    ${pool}=   Set Variable   ${subnet}.children[?(@.fvCepNetCfgPol.attributes.name=='{{ pool_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.name   {{ pool_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.startIp   {{ pool.start_ip | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.ip_pools.start_ip) }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.endIp   {{ pool.end_ip | default(defaults.apic.tenants.application_profiles.useg_endpoint_groups.subnets.ip_pools.end_ip) }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.dnsSearchSuffix   {{ pool.dns_search_suffix | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.dnsServers   {{ pool.dns_server | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.dnsSuffix   {{ pool.dns_suffix | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvCepNetCfgPol.attributes.winsServers   {{ pool.wins_server | default() }}

{% endfor %}

{% endfor %}

{% if epg.custom_qos_policy is defined %}
{% set custom_qos_policy_name = epg.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
Verify Endpoint Group {{ epg_name }} Custom QoS Policy
    Should Be Equal Value Json String   ${r.json()}   $..fvRsCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

{% if epg.tags is defined %}
Verify uSeg Endpoint Group {{ epg_name }} Tags
{% for tag in epg.tags | default([]) %}

    ${tag}=   Set Variable   $..fvAEPg.children[?(@.tagInst.attributes.name=='{{ tag }}')]
    Should Be Equal Value Json String   ${r.json()}   ${tag}..attributes.name   {{ tag }}

{% endfor %}

{% endif %}

{% for pool in epg.l4l7_address_pools | default([]) %}
Verify uSeg Endpoint Group {{ epg_name }} L4-L7 IP Address Pool {{ pool.name }}
    ${pool}=   Set Variable   $..fvAEPg.children[?(@.vnsAddrInst.attributes.name=='{{ pool.name }}')].vnsAddrInst    
    Should Be Equal Value Json String   ${r.json()}   ${pool}.attributes.name   {{ pool.name }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}.attributes.addr   {{ pool.gateway_address }}
{% if pool.from is defined and pool.to is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvnsUcastAddrBlk.attributes.from   {{ pool.from }}
    Should Be Equal Value Json String   ${r.json()}   ${pool}..fvnsUcastAddrBlk.attributes.to   {{ pool.to }}
{% endif %}

{% endfor %}

{% if epg.trust_control_policy is defined %}
{% set trust_control_policy_name = epg.trust_control_policy ~ defaults.apic.tenants.policies.trust_control_policies.name_suffix %}
Verify Endpoint Group {{ epg_name }} Trust Control Policy {{ trust_control_policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvRsTrustCtrl.attributes.tnFhsTrustCtrlPolName   {{ trust_control_policy_name }}
{% endif %}

{% endfor %}

{% endfor %}
