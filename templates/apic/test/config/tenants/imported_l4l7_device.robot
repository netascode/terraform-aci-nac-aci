{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Imported L4L7 Device
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for dev in tenant.services.imported_l4l7_devices | default([]) %}
{% set imported_dev_name = dev.name ~ defaults.apic.tenants.services.l4l7_devices.name_suffix %}

Verify Imported L4L7 Device {{ imported_dev_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/lDevIf-[uni/tn-{{ dev.tenant }}/lDevVip-{{ imported_dev_name }}].json
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevIf.attributes.ldev   uni/tn-{{ dev.tenant }}/lDevVip-{{ imported_dev_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsLDevIf.attributes.description   {{ dev.description | default() }}

{% endfor %}
