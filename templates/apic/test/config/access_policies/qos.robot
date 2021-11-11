*** Settings ***
Documentation   Verify QOS Class
Suite Setup     Login APIC
Default Tags    apic   day0   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify QoS COS presevation status
    GET   "/api/mo/uni/infra/qosinst-default.json?rsp-subtree=full"
    String   $..qosInstPol.attributes.ctrl   "{% if apic.access_policies.qos.preserve_cos | default(defaults.apic.access_policies.qos.preserve_cos) == "enabled" %}dot1p-preserve{% elif apic.access_policies.qos.preserve_cos | default(defaults.apic.access_policies.qos.preserve_cos) == "disabled" %}{% endif %}"

{% for level in range(1, 7) %}
{% set query = "qos_classes[?level==`" ~ level ~ "`]" %}
{% set default_qos_class = (defaults.apic.access_policies.qos | json_query(query))[0] %}
{% if apic.access_policies.qos is defined %}
{% set qos_class = ((apic.access_policies.qos | json_query(query)) | default([]))[0] %}
{% endif %}

Verify QoS Class Level {{ level }}
    ${level}=  Set Variable   $..qosInstPol.children[?(@.qosClass.attributes.prio=='level{{ level }}')]
    String   ${level}..qosClass.attributes.admin   {{ qos_class.admin_state | default(default_qos_class.admin_state) }}
    String   ${level}..qosClass.attributes.mtu   {{ qos_class.mtu | default(default_qos_class.mtu) }}
    String   ${level}..qosSched.attributes.meth   {% if qos_class.scheduling | default(default_qos_class.scheduling) == "wrr" %}wrr{% elif qos_class.scheduling | default(default_qos_class.scheduling) == "strict-priority" %}sp{% endif %} 
    String   ${level}..qosSched.attributes.bw   {{ qos_class.bandwidth_percent | default(default_qos_class.bandwidth_percent) }}
    String   ${level}..qosBuffer.attributes.min   {{ qos_class.minimum_buffer | default(default_qos_class.minimum_buffer) }}
    String   ${level}..qosPfcPol.attributes.adminSt   {% if qos_class.pfc_state | default(default_qos_class.pfc_state) == "enabled" %}yes{% else %}no{% endif %}
    String   ${level}..qosPfcPol.attributes.noDropCos   {{ qos_class.no_drop_cos | default(default_qos_class.no_drop_cos) }}
    String   ${level}..qosCong.attributes.algo   {{ qos_class.congestion_algorithm | default(default_qos_class.congestion_algorithm) }}
    String   ${level}..qosCong.attributes.ecn   {{ qos_class.ecn | default(default_qos_class.ecn) }}
    String   ${level}..qosCong.attributes.forwardNonEcn   {{ qos_class.forward_non_ecn | default(default_qos_class.forward_non_ecn) }}
    String   ${level}..qosCong.attributes.wredMaxThreshold   {{ qos_class.wred_max_threshold | default(default_qos_class.wred_max_threshold) }}
    String   ${level}..qosCong.attributes.wredMinThreshold   {{ qos_class.wred_min_threshold | default(default_qos_class.wred_min_threshold) }}
    String   ${level}..qosCong.attributes.wredProbability   {{ qos_class.wred_probability | default(default_qos_class.wred_probability) }}
    String   ${level}..qosCong.attributes.wredWeight   {{ qos_class.weight | default(default_qos_class.weight) }}
{% endfor %}
