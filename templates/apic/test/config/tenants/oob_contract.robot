{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify OOB Contract
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for contract in tenant.oob_contracts | default([]) %}
{% set contract_name = contract.name ~ defaults.apic.tenants.oob_contracts.name_suffix %}

Verify OOB Contract {{ contract_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/oobbrc-{{ contract_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vzOOBBrCP.attributes.name   {{ contract_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vzOOBBrCP.attributes.nameAlias   {{ contract.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vzOOBBrCP.attributes.descr   {{ contract.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vzOOBBrCP.attributes.scope   {{ contract.scope | default(defaults.apic.tenants.oob_contracts.scope) }}

{% for subject in contract.subjects | default([]) %}
{% set subject_name = subject.name ~ defaults.apic.tenants.oob_contracts.subjects.name_suffix %}

Verify OOB Contract {{ contract_name }} Subject {{ subject_name }}
    ${subject}=   Set Variable   $..vzOOBBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${subject}..vzSubj.attributes.name   {{ subject_name }}

{% for filter in subject.filters | default([]) %}
{% set filter_name = filter.filter ~ defaults.apic.tenants.filters.name_suffix %}

Verify OOB Contract {{ contract_name }} Subject {{ subject_name }} Filter {{ filter_name }}
    ${filter}=   Set Variable   $..vzOOBBrCP.children[?(@.vzSubj.attributes.name=='{{ subject_name }}')].vzSubj.children[?(@.vzRsSubjFiltAtt.attributes.tnVzFilterName=='{{ filter_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${filter}..vzRsSubjFiltAtt.attributes.tnVzFilterName   {{ filter_name }}

{% endfor %}

{% endfor %}

{% endfor %}
