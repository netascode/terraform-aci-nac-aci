*** Settings ***
Documentation   Verify Redirect Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for pol in tenant.services.redirect_policies | default([]) %}
{% set pol_name = pol.name ~ defaults.apic.tenants.services.redirect_policies.name_suffix %}

Verify Redirect Policy {{ pol_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/svcCont/svcRedirectPol-{{ pol_name }}.json?rsp-subtree=full"
    String   $..vnsSvcRedirectPol.attributes.descr   {{ pol.description | default() }}
    String   $..vnsSvcRedirectPol.attributes.name   {{ pol_name }}
    String   $..vnsSvcRedirectPol.attributes.nameAlias   {{ pol.alias | default() }}
    String   $..vnsSvcRedirectPol.attributes.destType   {{ pol.type | default(defaults.apic.tenants.services.redirect_policies.type) }}
    String   $..vnsSvcRedirectPol.attributes.hashingAlgorithm   {{ pol.hashing | default(defaults.apic.tenants.services.redirect_policies.hashing) }}
    String   $..vnsSvcRedirectPol.attributes.maxThresholdPercent   {{ pol.max_threshold | default(defaults.apic.tenants.services.redirect_policies.max_threshold) }}
    String   $..vnsSvcRedirectPol.attributes.minThresholdPercent   {{ pol.min_threshold | default(defaults.apic.tenants.services.redirect_policies.min_threshold) }}
    String   $..vnsSvcRedirectPol.attributes.thresholdDownAction   {{ pol.threshold_down_action | default(defaults.apic.tenants.services.redirect_policies.threshold_down_action) }}
    String   $..vnsSvcRedirectPol.attributes.programLocalPodOnly   {% if pol.pod_aware | default(defaults.apic.tenants.services.redirect_policies.pod_aware) == "enabled" %}yes{% else %}no{% endif %} 
    String   $..vnsSvcRedirectPol.attributes.resilientHashEnabled   {% if pol.resilient_hashing | default(defaults.apic.tenants.services.redirect_policies.resilient_hashing) == "enabled" %}yes{% else %}no{% endif %} 
    String   $..vnsSvcRedirectPol.attributes.AnycastEnabled   {% if pol.anycast | default(defaults.apic.tenants.services.redirect_policies.anycast) == "enabled" %}yes{% else %}no{% endif %} 
    String   $..vnsSvcRedirectPol.attributes.thresholdEnable   {% if pol.threshold | default(defaults.apic.tenants.services.redirect_policies.threshold) == "enabled" %}yes{% else %}no{% endif %} 

{% if pol.sla_policy is defined %}
{% set ip_sla_name = pol.sla_policy ~ defaults.apic.tenants.policies.ip_sla_policies.name_suffix %} 

Verify Redirect Policy {{ pol_name }} IP SLA Policy 
    String   $..vnsSvcRedirectPol.children..vnsRsIPSLAMonitoringPol.attributes.tDn   uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}

{% endif %}

{% if pol.resilient_hashing | default(defaults.apic.tenants.services.redirect_policies.resilient_hashing) == "enabled" and pol.redirect_backup_policy is defined %}
{% set backup_pol_name = pol.redirect_backup_policy ~ defaults.apic.tenants.services.redirect_backup_policies.name_suffix %}

Verify Redirect Policy {{ pol_name }} Backup Policy
    String   $..vnsSvcRedirectPol.children..vnsRsBackupPol.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/backupPol-{{ backup_pol_name }}

{% endif %}                                   

{% for dest in pol.l3_destinations | default([]) %}

Verify Redirect Policy {{ pol_name }} L3 Destination {{ dest.ip }}
    ${dest}=   Set Variable   $..vnsSvcRedirectPol.children[?(@.vnsRedirectDest.attributes.ip=='{{ dest.ip }}')].vnsRedirectDest
    String   ${dest}.attributes.descr   {{ dest.description | default() }}
    String   ${dest}.attributes.ip   {{ dest.ip }}
    String   ${dest}.attributes.ip2   {{ dest.ip_2 | default() }}
    String   ${dest}.attributes.mac   {{ dest.mac }}
    String   ${dest}.attributes.podId   {{ dest.pod | default(defaults.apic.tenants.services.redirect_policies.l3_destinations.pod) }}
{% if dest.redirect_health_group is defined %}
{% set health_group_name = dest.redirect_health_group ~ defaults.apic.tenants.services.redirect_health_groups.name_suffix %}
    String   ${dest}.children..vnsRsRedirectHealthGroup.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/redirectHealthGroup-{{ health_group_name }}
{% endif %}                                                 
{% endfor %}

{% endfor %}
