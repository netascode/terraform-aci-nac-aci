{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Redirect Policy
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for pol in tenant.services.redirect_policies | default([]) %}
{% set pol_name = pol.name ~ defaults.apic.tenants.services.redirect_policies.name_suffix %}

Verify Redirect Policy {{ pol_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/svcCont/svcRedirectPol-{{ pol_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.descr   {{ pol.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.nameAlias   {{ pol.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.destType   {{ pol.type | default(defaults.apic.tenants.services.redirect_policies.type) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.hashingAlgorithm   {{ pol.hashing | default(defaults.apic.tenants.services.redirect_policies.hashing) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.maxThresholdPercent   {{ pol.max_threshold | default(defaults.apic.tenants.services.redirect_policies.max_threshold) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.minThresholdPercent   {{ pol.min_threshold | default(defaults.apic.tenants.services.redirect_policies.min_threshold) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.thresholdDownAction   {{ pol.threshold_down_action | default(defaults.apic.tenants.services.redirect_policies.threshold_down_action) }}
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.programLocalPodOnly   {% if pol.pod_aware | default(defaults.apic.tenants.services.redirect_policies.pod_aware) | cisco.aac.aac_bool("enabled") == "enabled" %}yes{% else %}no{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.resilientHashEnabled   {% if pol.resilient_hashing | default(defaults.apic.tenants.services.redirect_policies.resilient_hashing) | cisco.aac.aac_bool("enabled") == "enabled" %}yes{% else %}no{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.AnycastEnabled   {% if pol.anycast | default(defaults.apic.tenants.services.redirect_policies.anycast) | cisco.aac.aac_bool("enabled") == "enabled" %}yes{% else %}no{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.attributes.thresholdEnable   {% if pol.threshold | default(defaults.apic.tenants.services.redirect_policies.threshold) | cisco.aac.aac_bool("enabled") == "enabled" %}yes{% else %}no{% endif %} 

{% if pol.sla_policy is defined %}
{% set ip_sla_name = pol.sla_policy ~ defaults.apic.tenants.policies.ip_sla_policies.name_suffix %} 

Verify Redirect Policy {{ pol_name }} IP SLA Policy 
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.children..vnsRsIPSLAMonitoringPol.attributes.tDn   uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ ip_sla_name }}

{% endif %}

{% if pol.resilient_hashing | default(defaults.apic.tenants.services.redirect_policies.resilient_hashing) == "enabled" and pol.redirect_backup_policy is defined %}
{% set backup_pol_name = pol.redirect_backup_policy ~ defaults.apic.tenants.services.redirect_backup_policies.name_suffix %}

Verify Redirect Policy {{ pol_name }} Backup Policy
    Should Be Equal Value Json String   ${r.json()}   $..vnsSvcRedirectPol.children..vnsRsBackupPol.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/backupPol-{{ backup_pol_name }}

{% endif %}                                   

{% for dest in pol.l3_destinations | default([]) %}

Verify Redirect Policy {{ pol_name }} L3 Destination {{ dest.ip }}
    ${dest}=   Set Variable   $..vnsSvcRedirectPol.children[?(@.vnsRedirectDest.attributes.ip=='{{ dest.ip }}')].vnsRedirectDest
    Should Be Equal Value Json String   ${r.json()}   ${dest}.attributes.descr   {{ dest.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${dest}.attributes.ip   {{ dest.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${dest}.attributes.ip2   {{ dest.ip_2 | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${dest}.attributes.mac   {{ dest.mac }}
    Should Be Equal Value Json String   ${r.json()}   ${dest}.attributes.podId   {{ dest.pod | default(defaults.apic.tenants.services.redirect_policies.l3_destinations.pod) }}
{% if dest.redirect_health_group is defined %}
{% set health_group_name = dest.redirect_health_group ~ defaults.apic.tenants.services.redirect_health_groups.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}   ${dest}.children..vnsRsRedirectHealthGroup.attributes.tDn   uni/tn-{{ tenant.name }}/svcCont/redirectHealthGroup-{{ health_group_name }}
{% endif %}                                                 
{% endfor %}

{% endfor %}
