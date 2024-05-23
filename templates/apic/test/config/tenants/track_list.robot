{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Track List
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for track_list in tenant.policies.track_lists | default([]) %}
{% set list_name = track_list.name ~ defaults.apic.tenants.policies.track_lists.name_suffix %}

Verify Track List {{ list_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/tracklist-{{ list_name }}.json    params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.name   {{ list_name }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.descr   {{ track_list.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.type   {{ track_list.type | default(defaults.apic.tenants.policies.track_lists.type) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.percentageDown   {{ track_list.percentage_down | default(defaults.apic.tenants.policies.track_lists.percentage_down) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.percentageUp   {{ track_list.percentage_up | default(defaults.apic.tenants.policies.track_lists.percentage_up) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.weightDown   {{ track_list.weight_down | default(defaults.apic.tenants.policies.track_lists.weight_down) }}
    Should Be Equal Value Json String   ${r.json()}   $..fvTrackList.attributes.weightUp   {{ track_list.weight_up | default(defaults.apic.tenants.policies.track_lists.weight_up) }}

{% for member in track_list.track_members | default([]) %}
    ${mem}=   Set Variable    $..fvTrackList.children[?(@.fvRsOtmListMember.attributes.tDn=='uni/tn-{{ tenant.name }}/trackmember-{{ member }}')]
    Should Be Equal Value Json String   ${r.json()}   ${mem}..fvRsOtmListMember.attributes.tDn   uni/tn-{{ tenant.name }}/trackmember-{{ member }}
{% endfor %}

{% endfor %}
