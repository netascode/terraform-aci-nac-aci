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
    GET   "/api/mo/uni/tn-{{ tenant.name }}/brc-{{ contract_name }}.json?rsp-subtree=full"
    String   $..vzBrCP.attributes.name   {{ contract_name }}
    String   $..vzBrCP.attributes.nameAlias   {{ contract.alias  | default() }}
    String   $..vzBrCP.attributes.descr   {{ contract.description | default() }}
    String   $..vzBrCP.attributes.scope   {{ contract.scope | default(defaults.apic.tenants.contracts.scope) }}
    String   $..vzBrCP.attributes.prio   {{ contract.qos_class | default(defaults.apic.tenants.contracts.qos_class) }}
    String   $..vzBrCP.attributes.targetDscp   {{ contract.target_dscp | default(defaults.apic.tenants.contracts.target_dscp) }}
{% if subject.service_graph is defined %}
    String   $..vzRsSubjGraphAtt.attributes.tnVnsAbsGraphName   {{ subject.service_graph }}
{% endif %}

{% for subject in contract.subjects | default([]) %}
{% set subject_name = subject.name ~ defaults.apic.tenants.contracts.subjects.name_suffix %}

Verify Contract {{ contract_name }} Subject {{ subject_name }}
    ${subject}=   Set Variable   $..vzBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')]
    String   ${subject}..vzSubj.attributes.name   {{ subject_name }}
    String   ${subject}..vzSubj.attributes.nameAlias   {{ subject.alias | default() }}
    String   ${subject}..vzSubj.attributes.descr   {{ subject.description | default() }}
    String   ${subject}..vzSubj.attributes.prio   {{ subject.qos_class | default(defaults.apic.tenants.contracts.subjects.qos_class) }}
    String   ${subject}..vzSubj.attributes.targetDscp   {{ subject.target_dscp | default(defaults.apic.tenants.contracts.subjects.target_dscp) }}

{% for filter in subject.filters | default([]) %}
{% set filter_name = filter.filter ~ defaults.apic.tenants.filters.name_suffix %}
{% set directives = [] %}
{% if filter.log | default(defaults.apic.tenants.contracts.subjects.filters.log) | cisco.aac.aac_bool("yes") == "yes" %}{% set directives = directives + [("log")] %}{% endif %}
{% if filter.no_stats | default(defaults.apic.tenants.contracts.subjects.filters.no_stats) | cisco.aac.aac_bool("yes") == "yes" %}{% set directives = directives + [("no-stats")] %}{% endif %}

Verify Contract {{ contract_name }} Subject {{ subject_name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $..vzBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')].vzSubj.children[?(@.vzRsSubjFiltAtt.attributes.tnVzFilterName=='{{ filter_name }}')]
    String   ${filter}..vzRsSubjFiltAtt.attributes.tnVzFilterName   {{ filter_name }}
    String   ${filter}..vzRsSubjFiltAtt.attributes.action   {{ filter.action | default(defaults.apic.tenants.contracts.subjects.filters.action) }}
    String   ${filter}..vzRsSubjFiltAtt.attributes.directives   {{ directives | join(',') }}
    String   ${filter}..vzRsSubjFiltAtt.attributes.priorityOverride   {{ filter.priority | default(defaults.apic.tenants.contracts.subjects.filters.priority) }}

{% endfor %}

{% endfor %}

{% endfor %}
