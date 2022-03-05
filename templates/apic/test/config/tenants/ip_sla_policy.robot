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
    GET   "/api/node/mo/uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}.json"
    String   $..fvIPSLAMonitoringPol.attributes.name   {{ ip_sla_name }}
    String   $..fvIPSLAMonitoringPol.attributes.descr   {{ ip_sla.description | default()}}    
    String   $..fvIPSLAMonitoringPol.attributes.slaDetectMultiplier   {{ ip_sla.multiplier | default(defaults.apic.tenants.policies.ip_sla_policies.multiplier) }}
    String   $..fvIPSLAMonitoringPol.attributes.slaFrequency   {{ ip_sla.frequency | default(defaults.apic.tenants.policies.ip_sla_policies.frequency) }}
    String   $..fvIPSLAMonitoringPol.attributes.slaPort   {{ ip_sla.port | default(defaults.apic.tenants.policies.ip_sla_policies.port) }}
    String   $..fvIPSLAMonitoringPol.attributes.slaType   {{ ip_sla.sla_type | default(defaults.apic.tenants.policies.ip_sla_policies.sla_type) }}

{% endfor %}
