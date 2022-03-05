*** Settings ***
Documentation   Verify VMware VMM Domain
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% set vmm_name = vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }}
    GET   "/api/mo/uni/vmmp-VMware/dom-{{ vmm_name }}.json?rsp-subtree=full"
    String   $..vmmDomP.attributes.name   {{ vmm_name }}
    String   $..vmmDomP.attributes.accessMode   {{ vmm.access_mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.access_mode) }}
    String   $..vmmDomP.attributes.enableTag   {{ vmm.tag_collection | default(defaults.apic.fabric_policies.vmware_vmm_domains.tag_collection) | cisco.aac.aac_bool("yes") }}
{% if vmm.vswitch.cdp_policy is defined %}
{% set cdp_policy_name = vmm.vswitch.cdp_policy ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix %}
    String   $..vmmRsVswitchOverrideCdpIfPol.attributes.tDn   uni/infra/cdpIfP-{{ cdp_policy_name }}
{% endif %}
{% if vmm.vswitch.lldp_policy is defined %}
{% set lldp_policy_name = vmm.vswitch.lldp_policy ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix %}
    String   $..vmmRsVswitchOverrideLldpIfPol.attributes.tDn   uni/infra/lldpIfP-{{ lldp_policy_name }}
{% endif %}
{% if vmm.vswitch.port_channel_policy is defined %}
{% set port_channel_policy_name = vmm.vswitch.port_channel_policy ~ defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix %}
    String   $..vmmRsVswitchOverrideLacpPol.attributes.tDn   uni/infra/lacplagp-{{ port_channel_policy_name }}
{% endif %}

{% for elag in vmm.vswitch.enhanced_lags | default([]) %}
{% set elag_name = elag.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.name_suffix %}
Verify VMware VMM Domain {{ vmm_name }} vSwitch Enhanced Lag Policy {{ elag_name }}                                       
   ${cp}=   Set Variable   $..vmmVSwitchPolicyCont.children[?(@.lacpEnhancedLagPol.attributes.name=='{{ elag_name }}')]
    String   ${cp}..lacpEnhancedLagPol.attributes.name   {{ elag_name }}
    String   ${cp}..lacpEnhancedLagPol.attributes.lbmode   {{ elag.lb_mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.lb_mode) }}
    String   ${cp}..lacpEnhancedLagPol.attributes.numLinks   {{ elag.num_links | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.num_links) }}
    String   ${cp}..lacpEnhancedLagPol.attributes.mode   {{ elag.mode | default(defaults.apic.fabric_policies.vmware_vmm_domains.vswitch.enhanced_lags.mode) }}
{% endfor %}

{% for cp in vmm.credential_policies | default([]) %}
{% set policy_name = cp.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }} Credential Policy {{ policy_name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUsrAccP.attributes.name=='{{ policy_name }}')]
    String   ${cp}..vmmUsrAccP.attributes.name   {{ policy_name }}
    String   ${cp}..vmmUsrAccP.attributes.usr   {{ cp.username }}

{% endfor %}

{% for vc in vmm.vcenters| default([]) %}
{% set vc_name = vc.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.name_suffix %}
{% set vc_policy_name = vc.credential_policy ~ defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }} vCenter {{ vc_name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmCtrlrP.attributes.name=='{{ vc_name }}')]
    String   ${cp}..vmmCtrlrP.attributes.name   {{ vc_name }}
    String   ${cp}..vmmCtrlrP.attributes.dvsVersion   {{ vc.dvs_version | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.dvs_version) }}
    String   ${cp}..vmmCtrlrP.attributes.hostOrIp   {{ vc.hostname_ip }}
    String   ${cp}..vmmCtrlrP.attributes.rootContName   {{ vc.datacenter }}
    String   ${cp}..vmmCtrlrP.attributes.statsMode   {{ vc.statistics | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.statistics) | cisco.aac.aac_bool("enabled") }}
    String   ${cp}..vmmRsAcc.attributes.tDn   uni/vmmp-VMware/dom-{{ vmm_name }}/usracc-{{ vc_policy_name }}
{% set mgmt_epg = vmm.mgmt_epg | default(defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.mgmt_epg) %}
{% if mgmt_epg == "inb" %}
    String   ${cp}..vmmRsMgmtEPg.attributes.tDn   uni/tn-mgmt/mgmtp-default/inb-{{ apic.node_policies.inb_endpoint_group | default(defaults.apic.node_policies.inb_endpoint_group) }}
{% endif %}

{% endfor %}

{% if vmm.uplinks is defined %}
Verify VMware VMM Domain {{ vmm_name }} Number of Uplinks
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUplinkPCont.attributes.id=='0')]
    String   ${cp}..vmmUplinkPCont.attributes.numOfUplinks   {{ vmm.uplinks | length }}
{% for ul in vmm.uplinks | default([]) %}
Verify VMware VMM Domain {{ vmm_name }} Uplink {{ ul.name }}
    ${cp}=   Set Variable   $..vmmDomP.children[?(@.vmmUplinkPCont.attributes.id=='0')]..vmmUplinkPCont.children[?(@.vmmUplinkP.attributes.uplinkId=='{{ ul.id }}')]
    String   ${cp}..vmmUplinkP.attributes.uplinkId   {{ ul.id }}
    String   ${cp}..vmmUplinkP.attributes.uplinkName   {{ ul.name }}
{% endfor %}
{% endif %}

{% endfor %}

