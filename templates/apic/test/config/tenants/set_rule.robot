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
    GET   "/api/mo/uni/tn-{{ tenant.name }}/attr-{{ rule_name }}.json?rsp-subtree=full"
    String   $..rtctrlAttrP.attributes.name   {{ rule_name }}
    String   $..rtctrlAttrP.attributes.descr   {{ rule.description | default() }}
{% if rule.community is defined %}
    String   $..rtctrlSetComm.attributes.community   {{ rule.community }}
    String   $..rtctrlSetComm.attributes.setCriteria   {{ rule.community_mode | default(defaults.apic.tenants.policies.set_rules.community_mode) }}
{% endif %}
{% if rule.tag is defined %}
    String   $..rtctrlSetTag.attributes.tag   {{ rule.tag }}
{% endif %}
{% if rule.dampening is defined %}
    String   $..rtctrlSetDamp.attributes.halfLife   {{ rule.dampening.half_life | default(defaults.apic.tenants.policies.set_rules.dampening.half_life ) }}
    String   $..rtctrlSetDamp.attributes.maxSuppressTime   {{ rule.dampening.max_suppress_time | default(defaults.apic.tenants.policies.set_rules.dampening.max_suppress_time ) }}
    String   $..rtctrlSetDamp.attributes.reuse   {{ rule.dampening.reuse_limit | default(defaults.apic.tenants.policies.set_rules.dampening.reuse_limit ) }}
    String   $..rtctrlSetDamp.attributes.suppress   {{ rule.dampening.suppress_limit | default(defaults.apic.tenants.policies.set_rules.dampening.suppress_limit ) }}
{% endif %}
{% if rule.weight is defined %}
    String   $..rtctrlSetWeight.attributes.weight   {{ rule.weight }}
{% endif %}
{% if rule.next_hop is defined %}
    String   $..rtctrlSetNh.attributes.addr   {{ rule.next_hop }}
{% endif %}
{% if rule.preference is defined %}
    String   $..rtctrlSetPref.attributes.localPref   {{ rule.preference }}
{% endif %}
{% if rule.metric is defined %}
    String   $..rtctrlSetRtMetric.attributes.metric   {{ rule.metric }}
{% endif %}
{% if rule.metric_type is defined %}
    String   $..rtctrlSetRtMetricType.attributes.metricType   {{ rule.metric_type }}
{% endif %}
{% if rule.set_as_path is defined %}
    String   $..rtctrlSetASPath.attributes.criteria   {{ rule.set_as_path.criteria | default(defaults.apic.tenants.policies.set_rules.set_as_path.criteria) }}
    String   $..rtctrlSetASPath.attributes.lastnum   {{ rule.set_as_path.count | default(defaults.apic.tenants.policies.set_rules.set_as_path.count) }}
{% if rule.set_as_path.criteria == 'prepend' %}
    String   $..rtctrlSetASPathASN.attributes.asn   {{ rule.set_as_path.asn }}
    String   $..rtctrlSetASPathASN.attributes.order   {{ rule.set_as_path.order | default(defaults.apic.tenants.policies.set_rules.set_as_path.order) }}"
{% endif %}
{% endif %}
{% if rule.next_hop_propagation | default(defaults.apic.tenants.policies.set_rules.next_hop_propagation) | cisco.aac.aac_bool("enabled") == 'enabled' %}
    String   $..rtctrlSetNhUnchanged.attributes.type   nh-unchanged
{% endif %}
{% if rule.multipath | default(defaults.apic.tenants.policies.set_rules.multipath) | cisco.aac.aac_bool("enabled") == 'enabled' %}
    String   $..rtctrlSetRedistMultipath.attributes.type   redist-multipath
{% endif %}

{% for add_comm in rule.additional_communities | default([]) %}
Verify Set Rule {{ rule_name }} Additional Community {{ add_comm.community  }}
    ${comm}=   Set Variable   $..children[?(@.rtctrlSetAddComm.attributes.community=='{{ add_comm.community }}')]
    String   ${comm}..attributes.community   {{ add_comm.community }}
    String   ${comm}..attributes.descr   {{ add_comm.description | default() }}                       
{% endfor %}

{% endfor %}
