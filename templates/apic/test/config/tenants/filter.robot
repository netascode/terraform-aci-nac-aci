{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Tenant Filter
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
# apic automatically convert 80 -> http and 443 -> https if it is set by api.
{% macro get_protocol_from_port(name) -%}
    {% set ports = {0:"unspecified",20:"ftpData",25:"smtp",53:"dns",110:"pop3",554:"rtsp",80:"http",443:"https",22:"ssh"} %}
    {{ ports[name] | default(name)}}
{% endmacro %}

{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for filter in tenant.filters | default([]) %}
{% set filter_name = filter.name ~ defaults.apic.tenants.filters.name_suffix %}

Verify Tenant {{ tenant.name }} Filter {{ filter_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/flt-{{ filter_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..vzFilter.attributes.name   {{ filter_name }}
    Should Be Equal Value Json String   ${r.json()}   $..vzFilter.attributes.nameAlias   {{ filter.alias  | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..vzFilter.attributes.descr   {{ filter.description | default() }}

{% for entry in filter.entries | default([]) %}
{% set entry_name = entry.name ~ defaults.apic.tenants.filters.entries.name_suffix %}

Verify Tenant {{ tenant.name }} Filter {{ filter.name }} Entry {{ entry_name }}
    ${filter_entry}=   Set Variable   $..vzFilter.children[?(@.vzEntry.attributes.name=='{{ entry_name }}')].vzEntry
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.name   {{ entry_name }}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.nameAlias   {{ entry.alias | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.etherT   {{ entry.ethertype | default(defaults.apic.tenants.filters.entries.ethertype) }}
{% if entry.ethertype | default(defaults.apic.tenants.filters.entries.ethertype) in ['ip', 'ipv4', 'ipv6'] %}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.prot   {{ entry.protocol | default(defaults.apic.tenants.filters.entries.protocol) }}
{% if entry.protocol | default(defaults.apic.tenants.filters.entries.protocol) in ['tcp', 'udp'] %}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.sFromPort   {{ get_protocol_from_port(entry.source_from_port | default(defaults.apic.tenants.filters.entries.source_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.sToPort   {{ get_protocol_from_port(entry.source_to_port| default(entry.source_from_port | default(defaults.apic.tenants.filters.entries.source_from_port))) }}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.dFromPort   {{ get_protocol_from_port(entry.destination_from_port | default(defaults.apic.tenants.filters.entries.destination_from_port)) }}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.dToPort   {{ get_protocol_from_port(entry.destination_to_port | default(entry.destination_from_port | default(defaults.apic.tenants.filters.entries.destination_from_port))) }}
{% if entry.protocol | default(defaults.apic.tenants.filters.entries.protocol) == 'tcp' %}
    Should Be Equal Value Json String   ${r.json()}   ${filter_entry}.attributes.stateful   {{ entry.stateful | default(defaults.apic.tenants.filters.entries.stateful) | cisco.aac.aac_bool("yes") }}
{% endif %}
{% endif %}
{% endif %}

{% endfor %}

{% endfor %}
