{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Set Rule
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for rule in tenant.policies.set_rules | default([]) %}
{% set rule_name = rule.name ~ defaults.apic.tenants.policies.set_rules.name_suffix %}

Verify Set Rule {{ rule_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/tn-{{ tenant.name }}/attr-{{ rule_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlAttrP.attributes.name   {{ rule_name }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlAttrP.attributes.descr   {{ rule.description | default() }}
{% if rule.community is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetComm.attributes.community   {{ rule.community }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetComm.attributes.setCriteria   {{ rule.community_mode | default(defaults.apic.tenants.policies.set_rules.community_mode) }}
{% endif %}
{% if rule.tag is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetTag.attributes.tag   {{ rule.tag }}
{% endif %}
{% if rule.dampening is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetDamp.attributes.halfLife   {{ rule.dampening.half_life | default(defaults.apic.tenants.policies.set_rules.dampening.half_life ) }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetDamp.attributes.maxSuppressTime   {{ rule.dampening.max_suppress_time | default(defaults.apic.tenants.policies.set_rules.dampening.max_suppress_time ) }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetDamp.attributes.reuse   {{ rule.dampening.reuse_limit | default(defaults.apic.tenants.policies.set_rules.dampening.reuse_limit ) }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetDamp.attributes.suppress   {{ rule.dampening.suppress_limit | default(defaults.apic.tenants.policies.set_rules.dampening.suppress_limit ) }}
{% endif %}
{% if rule.weight is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetWeight.attributes.weight   {{ rule.weight }}
{% endif %}
{% if rule.next_hop is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetNh.attributes.addr   {{ rule.next_hop }}
{% endif %}
{% if rule.preference is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetPref.attributes.localPref   {{ rule.preference }}
{% endif %}
{% if rule.metric is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetRtMetric.attributes.metric   {{ rule.metric }}
{% endif %}
{% if rule.metric_type is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetRtMetricType.attributes.metricType   {{ rule.metric_type }}
{% endif %}
{% if rule.set_as_path is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetASPath.attributes.criteria   {{ rule.set_as_path.criteria | default(defaults.apic.tenants.policies.set_rules.set_as_path.criteria) }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetASPath.attributes.lastnum   {{ rule.set_as_path.count | default(defaults.apic.tenants.policies.set_rules.set_as_path.count) }}
{% if rule.set_as_path.criteria == 'prepend' %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetASPathASN.attributes.asn   {{ rule.set_as_path.asn }}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetASPathASN.attributes.order   {{ rule.set_as_path.order | default(defaults.apic.tenants.policies.set_rules.set_as_path.order) }}
{% endif %}
{% endif %}
{% if rule.next_hop_propagation | default(defaults.apic.tenants.policies.set_rules.next_hop_propagation) | cisco.aac.aac_bool("enabled") == 'enabled' %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetNhUnchanged.attributes.type   nh-unchanged
{% endif %}
{% if rule.multipath | default(defaults.apic.tenants.policies.set_rules.multipath) | cisco.aac.aac_bool("enabled") == 'enabled' %}
    Should Be Equal Value Json String   ${r.json()}   $..rtctrlSetRedistMultipath.attributes.type   redist-multipath
{% endif %}

{% for add_comm in rule.additional_communities | default([]) %}
Verify Set Rule {{ rule_name }} Additional Community {{ add_comm.community  }}
    ${comm}=   Set Variable   $..children[?(@.rtctrlSetAddComm.attributes.community=='{{ add_comm.community }}')]
    Should Be Equal Value Json String   ${r.json()}   ${comm}..attributes.community   {{ add_comm.community }}
    Should Be Equal Value Json String   ${r.json()}   ${comm}..attributes.descr   {{ add_comm.description | default() }}                       
{% endfor %}

{% endfor %}
