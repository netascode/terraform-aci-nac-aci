*** Settings ***
Documentation   Verify VMware VMM Domain
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% set vmm_name = vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/vmmp-VMware/dom-{{ vmm_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..vmmDomP.attributes.name   {{ vmm_name }}
    Should Be Equal Value Json String   ${r.json()}    $..vmmDomP.attributes.accessMode   {{ vmm.access_mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.access_mode) }}
    Should Be Equal Value Json String   ${r.json()}    $..vmmDomP.attributes.enableTag   {{ vmm.tag_collection | default(defaults.apic.fabric_policies.vmware_vmm_domains.tag_collection) | cisco.aac.aac_bool("yes") }}
{% if vmm.vswitch.cdp_policy is defined %}
{% set cdp_policy_name = vmm.vswitch.cdp_policy ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..vmmRsVswitchOverrideCdpIfPol.attributes.tDn   uni/infra/cdpIfP-{{ cdp_policy_name }}
{% endif %}
{% if vmm.vswitch.lldp_policy is defined %}
{% set lldp_policy_name = vmm.vswitch.lldp_policy ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..vmmRsVswitchOverrideLldpIfPol.attributes.tDn   uni/infra/lldpIfP-{{ lldp_policy_name }}
{% endif %}
{% if vmm.vswitch.port_channel_policy is defined %}
{% set port_channel_policy_name = vmm.vswitch.port_channel_policy ~ defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..vmmRsVswitchOverrideLacpPol.attributes.tDn   uni/infra/lacplagp-{{ port_channel_policy_name }}
{% endif %}
{% if vmm.vswitch.mtu_policy is defined %}
{% set mtu_policy_name = vmm.vswitch.mtu_policy ~ defaults.apic.fabric_policies.l2_mtu_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..vmmRsVswitchOverrideMtuPol.attributes.tDn   uni/fabric/l2pol-{{ mtu_policy_name }}
{% endif %}

{% for elag in vmm.vswitch.enhanced_lags | default([]) %}
{% set elag_name = elag.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.name_suffix %}
Verify VMware VMM Domain {{ vmm_name }} vSwitch Enhanced Lag Policy {{ elag_name }}                                       
   ${cp}=   Set Variable   $..vmmVSwitchPolicyCont.children[?(@.lacpEnhancedLagPol.attributes.name=='{{ elag_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cp}..lacpEnhancedLagPol.attributes.name   {{ elag_name }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..lacpEnhancedLagPol.attributes.lbmode   {{ elag.lb_mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.lb_mode) }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..lacpEnhancedLagPol.attributes.numLinks   {{ elag.num_links | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.num_links) }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..lacpEnhancedLagPol.attributes.mode   {{ elag.mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.mode) }}
{% endfor %}

{% for cp in vmm.credential_policies | default([]) %}
{% set policy_name = cp.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }} Credential Policy {{ policy_name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUsrAccP.attributes.name=='{{ policy_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmUsrAccP.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmUsrAccP.attributes.usr   {{ cp.username }}

{% endfor %}

{% for vc in vmm.vcenters| default([]) %}
{% set vc_name = vc.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.name_suffix %}
{% set vc_policy_name = vc.credential_policy ~ defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }} vCenter {{ vc_name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmCtrlrP.attributes.name=='{{ vc_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmCtrlrP.attributes.name   {{ vc_name }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmCtrlrP.attributes.dvsVersion   {{ vc.dvs_version | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.dvs_version) }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmCtrlrP.attributes.hostOrIp   {{ vc.hostname_ip }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmCtrlrP.attributes.rootContName   {{ vc.datacenter }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmCtrlrP.attributes.statsMode   {{ vc.statistics | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.statistics) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmRsAcc.attributes.tDn   uni/vmmp-VMware/dom-{{ vmm_name }}/usracc-{{ vc_policy_name }}
{% set mgmt_epg = vmm.mgmt_epg | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.mgmt_epg) %}
{% if mgmt_epg == "inb" %}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmRsMgmtEPg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}

{% if vmm.uplinks is defined %}
Verify VMware VMM Domain {{ vmm_name }} Number of Uplinks
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUplinkPCont.attributes.id=='0')]
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmUplinkPCont.attributes.numOfUplinks   {{ vmm.uplinks | length }}
{% for ul in vmm.uplinks | default([]) %}
Verify VMware VMM Domain {{ vmm_name }} Uplink {{ ul.name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUplinkPCont.attributes.id=='0')]..vmmUplinkPCont.children[?(@.vmmUplinkP.attributes.uplinkId=='{{ ul.id }}')]
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmUplinkP.attributes.uplinkId   {{ ul.id }}
    Should Be Equal Value Json String   ${r.json()}    ${cp}..vmmUplinkP.attributes.uplinkName   {{ ul.name }}
{% endfor %}
{% endif %}

{% endfor %}

