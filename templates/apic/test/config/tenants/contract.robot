{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Contract
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for contract in tenant.contracts | default([]) %}
{% set contract_name = contract.name ~ defaults.apic.tenants.contracts.name_suffix %}

Verify Contract {{ contract_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/brc-{{ contract_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.name   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.nameAlias   {{ contract.alias  | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.descr   {{ contract.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.scope   {{ contract.scope | default(defaults.apic.tenants.contracts.scope) }}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.prio   {{ contract.qos_class | default(defaults.apic.tenants.contracts.qos_class) }}
    Should Be Equal Value Json String   ${r.json()}   $..vzBrCP.attributes.targetDscp   {{ contract.target_dscp | default(defaults.apic.tenants.contracts.target_dscp) }}
{% if subject.service_graph is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..vzRsSubjGraphAtt.attributes.tnVnsAbsGraphName   {{ subject.service_graph }}
{% endif %}

{% for subject in contract.subjects | default([]) %}
{% set subject_name = subject.name ~ defaults.apic.tenants.contracts.subjects.name_suffix %}

Verify Contract {{ contract_name }} Subject {{ subject_name }}
    ${subject}=   Set Variable   $..vzBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.name   {{ subject_name }}
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.nameAlias   {{ subject.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.descr   {{ subject.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.prio   {{ subject.qos_class | default(defaults.apic.tenants.contracts.subjects.qos_class) }}
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.targetDscp   {{ subject.target_dscp | default(defaults.apic.tenants.contracts.subjects.target_dscp) }}

{% for filter in subject.filters | default([]) %}
{% set filter_name = filter.filter ~ defaults.apic.tenants.filters.name_suffix %}
{% set directives = [] %}
{% if filter.log | default(defaults.apic.tenants.contracts.subjects.filters.log) | cisco.aac.aac_bool("yes") == "yes" %}{% set directives = directives + [("log")] %}{% endif %}
{% if filter.no_stats | default(defaults.apic.tenants.contracts.subjects.filters.no_stats) | cisco.aac.aac_bool("yes") == "yes" %}{% set directives = directives + [("no-stats")] %}{% endif %}

Verify Contract {{ contract_name }} Subject {{ subject_name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $..vzBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')].vzSubj.children[?(@.vzRsSubjFiltAtt.attributes.tnVzFilterName=='{{ filter_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${filter}..vzRsSubjFiltAtt.attributes.tnVzFilterName   {{ filter_name }}
    Should Be Equal Value Json String   ${r.json()}   ${filter}..vzRsSubjFiltAtt.attributes.action   {{ filter.action | default(defaults.apic.tenants.contracts.subjects.filters.action) }}
    Should Be Equal Value Json String   ${r.json()}   ${filter}..vzRsSubjFiltAtt.attributes.directives   {{ directives | join(',') }}
    Should Be Equal Value Json String   ${r.json()}   ${filter}..vzRsSubjFiltAtt.attributes.priorityOverride   {{ filter.priority | default(defaults.apic.tenants.contracts.subjects.filters.priority) }}

{% endfor %}

{% endfor %}

{% endfor %}
