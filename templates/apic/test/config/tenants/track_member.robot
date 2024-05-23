{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Track Member
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for member in tenant.policies.track_members | default([]) %}

Verify Track Member {{ member.name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/trackmember-{{ member.name }}.json    params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackMember.attributes.name   {{ member.name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackMember.attributes.descr   {{ member.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackMember.attributes.dstIpAddr   {{ member.destination_ip }}
{% if member.scope_type == "l3out" %}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackMember.attributes.scopeDn   uni/tn-{{ tenant.name }}/out-{{ member.scope }}
{% elif member.scope_type == "bd" %}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackMember.attributes.scopeDn   uni/tn-{{ tenant.name }}/BD-{{ member.scope }}
{% endif %}
    Should Be Equal Value Json String   ${r.json()}   $..fvRsIpslaMonPol.attributes.tDn   uni/tn-{{ tenant.name }}/ipslaMonitoringPol-{{ member.ip_sla_policy }}

{% endfor %}
