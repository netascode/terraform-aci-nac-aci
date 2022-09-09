{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify IP SLA Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for ip_sla in tenant.policies.ip_sla_policies | default([]) %}
{% set ip_sla_name = ip_sla.name ~ defaults.apic.tenants.policies.ip_sla_policies.name_suffix %} 

Verify IP SLA Policy {{ ip_sla_name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.name   {{ ip_sla_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.descr   {{ ip_sla.description | default()}}    
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.slaDetectMultiplier   {{ ip_sla.multiplier | default(defaults.apic.tenants.policies.ip_sla_policies.multiplier) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.slaFrequency   {{ ip_sla.frequency | default(defaults.apic.tenants.policies.ip_sla_policies.frequency) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.slaPort   {{ ip_sla.port | default(defaults.apic.tenants.policies.ip_sla_policies.port) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvIPSLAMonitoringPol.attributes.slaType   {{ ip_sla.sla_type | default(defaults.apic.tenants.policies.ip_sla_policies.sla_type) }}

{% endfor %}
