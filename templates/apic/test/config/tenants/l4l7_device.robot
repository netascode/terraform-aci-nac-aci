{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify L4L7 Device
Suite Setup    Login APIC
Default Tags    apic   day2   config   tenants
Resource       ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for dev in tenant.services.l4l7_devices | default([]) %}
{% set dev_name = dev.name ~ defaults.apic.tenants.services.l4l7_devices.name_suffix %}

Verify L4L7 Device {{ dev_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/lDevVip-{{ dev_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.contextAware   {{ dev.context_aware | default(defaults.apic.tenants.services.l4l7_devices.context_aware) }} 
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.devtype   {{ dev.type | default(defaults.apic.tenants.services.l4l7_devices.type) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.funcType   {{ dev.function | default(defaults.apic.tenants.services.l4l7_devices.function) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.isCopy   {{ dev.copy_device | default(defaults.apic.tenants.services.l4l7_devices.copy_device) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.managed   {{ dev.managed | default(defaults.apic.tenants.services.l4l7_devices.managed) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.name   {{ dev_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.nameAlias   {{ dev.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.promMode   {{ dev.promiscuous_mode | default(defaults.apic.tenants.services.l4l7_devices.promiscuous_mode) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.svcType   {{ dev.service_type | default(defaults.apic.tenants.services.l4l7_devices.service_type) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevVip.attributes.trunking   {{ dev.trunking | default(defaults.apic.tenants.services.l4l7_devices.trunking) | cisco.aac.aac_bool("yes") }}
{% if dev.physical_domain is defined and dev.type | default(defaults.apic.tenants.services.l4l7_devices.type) == 'PHYSICAL' %}
{% set domain_name = dev.physical_domain ~ defaults.apic.access_policies.physical_domains.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..vnsRsALDevToPhysDomP.attributes.tDn   uni/phys-{{ domain_name }}
{% endif %}
{% if dev.vmware_vmm_domain is defined and dev.type | default(defaults.apic.tenants.services.l4l7_devices.type) == 'VIRTUAL' %}
{% set domain_name = dev.vmware_vmm_domain ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   $..vnsRsALDevToDomP.attributes.tDn   uni/vmmp-VMware/dom-{{ domain_name }}
{% endif %}

{% for cd in dev.concrete_devices | default([]) %}
{% set cd_name = cd.name ~ defaults.apic.tenants.services.l4l7_devices.concrete_devices.name_suffix %}

Verify L4L7 Device {{ dev_name }} Concrete Device {{ cd_name }}
    ${con}=   Set Variable   $..vnsLDevVip.children[?(@.vnsCDev.attributes.name=='{{ cd_name }}')].vnsCDev
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.name   {{ cd_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.nameAlias   {{ cd.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.vcenterName   {{ cd.vcenter_name | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.vmName   {{ cd.vm_name | default() }}

{% for int in cd.interfaces | default([]) %}
{% set int_name = int.name ~ defaults.apic.tenants.services.l4l7_devices.concrete_devices.interfaces.name_suffix %}

Verify L4L7 Device {{ dev_name }} Concrete Device {{ cd_name }} Interface {{ int_name }}
    ${con}=   Set Variable   $..vnsLDevVip.children[?(@.vnsCDev.attributes.name=='{{ cd_name }}')].vnsCDev.children[?(@.vnsCIf.attributes.name=='{{ int_name }}')].vnsCIf
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.name   {{ int_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.nameAlias   {{ int.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.vnicName   {{ int.vnic_name | default() }}
{% if int.node_id is defined and int.channel is not defined %}
{% set query = "nodes[?id==`" ~ int.node_id ~ "`].pod" %}
{% set pod = int.pod_id | default((apic.node_policies | community.general.json_query(query))[0] | default('1')) %}
{% if int.fex_id is defined %}
    Should Be Equal Value Json String   ${r.json()}   ${con}..vnsRsCIfPathAtt.attributes.tDn   topology/pod-{{ pod }}/paths-{{ int.node_id }}/extpaths-{{ int.fex_id }}/pathep-[eth{{ int.module | default(defaults.apic.tenants.services.l4l7_devices.concrete_devices.interfaces.module) }}/{{ int.port }}]
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${con}..vnsRsCIfPathAtt.attributes.tDn   topology/pod-{{ pod }}/paths-{{ int.node_id }}/pathep-[eth{{ int.module | default(defaults.apic.tenants.services.l4l7_devices.concrete_devices.interfaces.module) }}/{{ int.port }}]
{% endif %}
{% else %}
{% set query = "leaf_interface_policy_groups[?name==`" ~ int.channel ~ "`].type" %}
{% set type = (apic.access_policies | community.general.json_query(query))[0] | default('vpc' if int.node2_id is defined else 'pc') %}
{% if int.node_id is defined %}
    {% set node = int.node_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node = (apic.interface_policies | default() | community.general.json_query(query))[0] %}
{% endif %}
{% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
{% set pod = int.pod_id | default((apic.node_policies | community.general.json_query(query))[0] | default('1')) %}
{% set policy_group_name = int.channel ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix %}
{% if type == 'vpc' %}
{% if int.node2_id is defined %}
    {% set node2 = int.node2_id %}
{% else %}
    {% set query = "nodes[?interfaces[?policy_group==`" ~ int.channel ~ "`]].id" %}
    {% set node2 = (apic.interface_policies | default() | community.general.json_query(query))[1] %}
    {% if node2 < node %}{% set node_tmp = node %}{% set node = node2 %}{% set node2 = node_tmp %}{% endif %}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   ${con}..vnsRsCIfPathAtt.attributes.tDn   topology/pod-{{ pod }}/protpaths-{{ node }}-{{ node2 }}/pathep-[{{ policy_group_name }}]
{% else %}
    Should Be Equal Value Json String   ${r.json()}   ${con}..vnsRsCIfPathAtt.attributes.tDn   topology/pod-{{ pod }}/paths-{{ node }}/pathep-[{{ policy_group_name }}]
{% endif %}
{% endif %}

{% endfor %}

{% endfor %}

{% for int in dev.logical_interfaces | default([]) %}
{% set int_name = int.name ~ defaults.apic.tenants.services.l4l7_devices.logical_interfaces.name_suffix %}

Verify L4L7 Device {{ dev_name }} Logical Interface {{ int_name }}
    ${con}=   Set Variable   $..vnsLDevVip.children[?(@.vnsLIf.attributes.name=='{{ int_name }}')].vnsLIf
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.name   {{ int_name }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.nameAlias   {{ int.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${con}.attributes.encap   {% if int.vlan is defined %}vlan-{{ int.vlan }}{% else %}unknown{% endif %} 

{% for ci in int.concrete_interfaces | default([]) %}
{% set ci_name = ci.interface_name ~ defaults.apic.tenants.services.l4l7_devices.logical_interfaces.concrete_interfaces.name_suffix  %}
{% set cd_name = ci.device ~ defaults.apic.tenants.services.l4l7_devices.concrete_devices.name_suffix %}

Verify L4L7 Device {{ dev_name }} Logical Interface {{ int_name }} Concrete Interface {{ ci_name }}
    ${int}=   Set Variable   $..vnsLDevVip.children[?(@.vnsLIf.attributes.name=='{{ int_name }}')].vnsLIf.children[?(@.vnsRsCIfAttN.attributes.tDn=='uni/tn-{{ tenant.name }}/lDevVip-{{ dev_name }}/cDev-{{ cd_name }}/cIf-[{{ ci_name }}]')].vnsRsCIfAttN
    Should Be Equal Value Json String   ${r.json()}   ${int}.attributes.tDn   uni/tn-{{ tenant.name }}/lDevVip-{{ dev_name }}/cDev-{{ cd_name }}/cIf-[{{ ci_name }}]

{% endfor %}

{% endfor %}

{% endfor %}
