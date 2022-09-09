*** Settings ***
Documentation   Verify QOS Class
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify QoS COS presevation status
    ${r}=   GET On Session   apic   /api/mo/uni/infra/qosinst-default.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..qosInstPol.attributes.ctrl   {% if apic.access_policies.qos.preserve_cos | default(defaults.apic.access_policies.qos.preserve_cos) | cisco.aac.aac_bool("enabled") == "enabled" %}dot1p-preserve{% elif apic.access_policies.qos.preserve_cos | default(defaults.apic.access_policies.qos.preserve_cos) | cisco.aac.aac_bool("enabled") == "disabled" %}{% endif %} 

{% for level in range(1, 7) %}
{% set query = "qos_classes[?level==`" ~ level ~ "`]" %}
{% set default_qos_class = (defaults.apic.access_policies.qos | community.general.json_query(query))[0] %}
{% if apic.access_policies.qos is defined %}
{% set qos_class = ((apic.access_policies.qos | community.general.json_query(query)) | default([]))[0] %}
{% endif %}

Verify QoS Class Level {{ level }}
    ${level}=  Set Variable   $..qosInstPol.children[?(@.qosClass.attributes.prio=='level{{ level }}')]
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosClass.attributes.admin   {{ qos_class.admin_state | default(default_qos_class.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosClass.attributes.mtu   {{ qos_class.mtu | default(default_qos_class.mtu) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosSched.attributes.meth   {% if qos_class.scheduling | default(default_qos_class.scheduling) == "wrr" %}wrr{% elif qos_class.scheduling | default(default_qos_class.scheduling) == "strict-priority" %}sp{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosSched.attributes.bw   {{ qos_class.bandwidth_percent | default(default_qos_class.bandwidth_percent) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosBuffer.attributes.min   {{ qos_class.minimum_buffer | default(default_qos_class.minimum_buffer) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosPfcPol.attributes.adminSt   {% if qos_class.pfc_state | default(default_qos_class.pfc_state) | cisco.aac.aac_bool("enabled") == "enabled" %}yes{% else %}no{% endif %} 
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosPfcPol.attributes.noDropCos   {{ qos_class.no_drop_cos | default(default_qos_class.no_drop_cos) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.algo   {{ qos_class.congestion_algorithm | default(default_qos_class.congestion_algorithm) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.ecn   {{ qos_class.ecn | default(default_qos_class.ecn) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.forwardNonEcn   {{ qos_class.forward_non_ecn | default(default_qos_class.forward_non_ecn) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.wredMaxThreshold   {{ qos_class.wred_max_threshold | default(default_qos_class.wred_max_threshold) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.wredMinThreshold   {{ qos_class.wred_min_threshold | default(default_qos_class.wred_min_threshold) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.wredProbability   {{ qos_class.wred_probability | default(default_qos_class.wred_probability) }}
    Should Be Equal Value Json String   ${r.json()}    ${level}..qosCong.attributes.wredWeight   {{ qos_class.weight | default(default_qos_class.weight) }}
{% endfor %}
