{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Service Graph Template
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for sgt in tenant.services.service_graph_templates | default([]) %}
{% set sgt_name = sgt.name ~ defaults.apic.tenants.services.service_graph_templates.name_suffix %}
{% set ten = sgt.device.tenant | default(tenant.name) %}
{% set query1 = "tenants[?name==`" ~ ten ~ "`]" %}
{% set query2 = "services.l4l7_devices[?name==`" ~ sgt.device.name ~ "`]" %}
{% set t = (apic | community.general.json_query(query1))[0] %}
{% set dev = (t | community.general.json_query(query2))[0] %}
{% set dev_name = sgt.device.name  ~ defaults.apic.tenants.services.l4l7_devices.name_suffix %}

Verify Service Graph Template {{ sgt_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/AbsGraph-{{ sgt_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsGraph.attributes.name   {{ sgt_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsGraph.attributes.nameAlias   {{ sgt.alias  | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsGraph.attributes.descr   {{ sgt.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.funcTemplateType   {{ sgt.template_type | default(defaults.apic.tenants.services.service_graph_templates.template_type) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.funcType   {{ dev.function | default(defaults.apic.tenants.services.l4l7_devices.function) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.isCopy   {{ dev.copy_device | default(defaults.apic.tenants.services.l4l7_devices.copy_device) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.managed   {{ dev.managed | default(defaults.apic.tenants.services.l4l7_devices.managed) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.routingMode   {{ 'Redirect' if sgt.redirect | default(defaults.apic.tenants.services.service_graph_templates.redirect) | cisco.aac.aac_bool("enabled") == 'enabled' else 'unspecified' }} 
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsNode.attributes.shareEncap   {{ 'yes' if sgt.share_encapsulation | default(defaults.apic.tenants.services.service_graph_templates.share_encapsulation)  | cisco.aac.aac_bool("enabled") == 'enabled' else 'no' }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsRsNodeToLDev.attributes.tDn   uni/tn-{{ sgt.device.tenant | default(tenant.name) }}/lDevVip-{{ dev_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsGraph.children[?(@.vnsAbsConnection.attributes.name=='C1')].vnsAbsConnection.attributes.directConnect   {{ 'yes' if sgt.consumer.direct_connect | default(defaults.apic.tenants.services.service_graph_templates.consumer.direct_connect) else 'no' }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsAbsGraph.children[?(@.vnsAbsConnection.attributes.name=='C2')].vnsAbsConnection.attributes.directConnect   {{ 'yes' if sgt.provider.direct_connect | default(defaults.apic.tenants.services.service_graph_templates.provider.direct_connect) else 'no' }}

{% endfor %}
