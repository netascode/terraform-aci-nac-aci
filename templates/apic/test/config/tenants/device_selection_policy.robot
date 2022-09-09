{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Device Selection Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for dsp in tenant.services.device_selection_policies | default([]) %}
{% set query = "service_graph_templates[?name==`" ~ dsp.service_graph_template ~ "`]" %}
{% set sgt = (tenant.services | community.general.json_query(query))[0] %}
{% set contract_name = dsp.contract ~ defaults.apic.tenants.contracts.name_suffix %}
{% set sgt_name = dsp.service_graph_template ~ defaults.apic.tenants.services.service_graph_templates.name_suffix %}
{% set dev_name = sgt.device.name ~ defaults.apic.tenants.services.l4l7_devices.name_suffix %}

Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/ldevCtx-c-{{ contract_name }}-g-{{ sgt_name }}-n-N1.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevCtx.attributes.ctrctNameOrLbl   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevCtx.attributes.graphNameOrLbl   {{ sgt_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsRsLDevCtxToLDev.attributes.tDn   uni/tn-{{ sgt.device.tenant | default(tenant.name) }}/lDevVip-{{ dev_name }}

Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Consumer
    ${consumer}=   Set Variable   $..vnsLDevCtx.children[?(@.vnsLIfCtx.attributes.connNameOrLbl=='consumer')]
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsLIfCtx.attributes.l3Dest   {{ 'yes' if dsp.consumer.l3_destination | default(defaults.apic.tenants.services.device_selection_policies.consumer.l3_destination) | cisco.aac.aac_bool("enabled") == 'enabled' else 'no'}}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsLIfCtx.attributes.permitLog   {{ 'yes' if dsp.consumer.permit_logging | default(defaults.apic.tenants.services.device_selection_policies.consumer.permit_logging) | cisco.aac.aac_bool("enabled") == 'enabled' else 'no'}}
{% if dsp.consumer.redirect_policy is defined %}
{% set pol_name = dsp.consumer.redirect_policy.name ~ defaults.apic.tenants.services.redirect_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToSvcRedirectPol.attributes.tDn   uni/tn-{{ dsp.consumer.redirect_policy.tenant | default(tenant.name) }}/svcCont/svcRedirectPol-{{ pol_name }}
{% endif %}
{% if dsp.consumer.bridge_domain is defined %}
{% set bd_name = dsp.consumer.bridge_domain.name ~ defaults.apic.tenants.bridge_domains.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToBD.attributes.tDn   uni/tn-{{ dsp.consumer.bridge_domain.tenant | default(tenant.name) }}/BD-{{ bd_name }}
{% elif dsp.consumer.external_endpoint_group is defined %}
{% set redistribute = [] %}
{% if dsp.consumer.external_endpoint_group.redistribute.bgp | default(defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.bgp) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("bgp")] %}{% endif %}
{% if dsp.consumer.external_endpoint_group.redistribute.ospf | default(defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.ospf) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("ospf")] %}{% endif %}
{% if dsp.consumer.external_endpoint_group.redistribute.connected | default(defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.connected) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("connected")] %}{% endif %}
{% if dsp.consumer.external_endpoint_group.redistribute.static | default(defaults.apic.tenants.services.device_selection_policies.consumer.external_endpoint_group.redistribute.static) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("static")] %}{% endif %}
{% set l3out_name = dsp.consumer.external_endpoint_group.l3out ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set eepg_name = dsp.consumer.external_endpoint_group.name ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToInstP.attributes.redistribute   {{ redistribute | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToInstP.attributes.tDn   uni/tn-{{ dsp.consumer.external_endpoint_group.tenant | default(tenant.name) }}/out-{{ l3out_name }}/instP-{{ eepg_name }}
{% set int_name = dsp.consumer.logical_interface ~ defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToLIf.attributes.tDn   uni/tn-{{ sgt.device.tenant | default(tenant.name) }}/lDevVip-{{ dev_name }}/lIf-{{ int_name }}
{% endif %}
{% if dsp.consumer.service_epg_policy is defined %}
{% set pol_name = dsp.consumer.service_epg_policy ~ defaults.apic.tenants.services.service_epg_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToSvcEPgPol.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/svcEPgPol-{{ pol_name }}
{% endif %}
{% if dsp.consumer.custom_qos_policy is defined %}
{% set custom_qos_policy_name = dsp.consumer.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${consumer}..vnsRsLIfCtxToCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

Verify Device Selection Policy Contract {{ contract_name }} Service Graph Template {{ sgt_name }} Provider
    ${provider}=   Set Variable   $..vnsLDevCtx.children[?(@.vnsLIfCtx.attributes.connNameOrLbl=='provider')]
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsLIfCtx.attributes.l3Dest   {{ 'yes' if dsp.provider.l3_destination | default(defaults.apic.tenants.services.device_selection_policies.provider.l3_destination) | cisco.aac.aac_bool("enabled") == 'enabled' else 'no'}}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsLIfCtx.attributes.permitLog   {{ 'yes' if dsp.provider.permit_logging | default(defaults.apic.tenants.services.device_selection_policies.provider.permit_logging) | cisco.aac.aac_bool("enabled") == 'enabled' else 'no'}}
{% if dsp.provider.redirect_policy is defined %}
{% set pol_name = dsp.provider.redirect_policy.name ~ defaults.apic.tenants.services.redirect_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToSvcRedirectPol.attributes.tDn   uni/tn-{{ dsp.provider.redirect_policy.tenant | default(tenant.name) }}/svcCont/svcRedirectPol-{{ pol_name }}
{% endif %}
{% if dsp.provider.bridge_domain is defined %}
{% set bd_name = dsp.provider.bridge_domain.name ~ defaults.apic.tenants.bridge_domains.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToBD.attributes.tDn   uni/tn-{{ dsp.provider.bridge_domain.tenant | default(tenant.name) }}/BD-{{ bd_name }}
{% elif dsp.provider.external_endpoint_group is defined %}
{% set redistribute = [] %}
{% if dsp.provider.external_endpoint_group.redistribute.bgp | default(defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.bgp) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("bgp")] %}{% endif %}
{% if dsp.provider.external_endpoint_group.redistribute.ospf | default(defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.ospf) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("ospf")] %}{% endif %}
{% if dsp.provider.external_endpoint_group.redistribute.connected | default(defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.connected) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("connected")] %}{% endif %}
{% if dsp.provider.external_endpoint_group.redistribute.static | default(defaults.apic.tenants.services.device_selection_policies.provider.external_endpoint_group.redistribute.static) | cisco.aac.aac_bool("enabled") == "enabled" %}{% set redistribute = redistribute + [("static")] %}{% endif %}
{% set l3out_name = dsp.provider.external_endpoint_group.l3out ~ defaults.apic.tenants.l3outs.name_suffix %}
{% set eepg_name = dsp.provider.external_endpoint_group.name ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToInstP.attributes.redistribute   {{ redistribute | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToInstP.attributes.tDn   uni/tn-{{ dsp.provider.external_endpoint_group.tenant | default(tenant.name) }}/out-{{ l3out_name }}/instP-{{ eepg_name }}
{% set int_name = dsp.provider.logical_interface ~ defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToLIf.attributes.tDn   uni/tn-{{ sgt.device.tenant | default(tenant.name) }}/lDevVip-{{ dev_name }}/lIf-{{ int_name }}
{% endif %}
{% if dsp.provider.service_epg_policy is defined %}
{% set pol_name = dsp.provider.service_epg_policy ~ defaults.apic.tenants.services.service_epg_policies.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToSvcEPgPol.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/svcEPgPol-{{ pol_name }}
{% endif %}
{% if dsp.provider.custom_qos_policy is defined %}
{% set custom_qos_policy_name = dsp.provider.custom_qos_policy ~ defaults.apic.tenants.policies.custom_qos.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${provider}..vnsRsLIfCtxToCustQosPol.attributes.tnQosCustomPolName   {{ custom_qos_policy_name }}
{% endif %}

{% endfor %}
