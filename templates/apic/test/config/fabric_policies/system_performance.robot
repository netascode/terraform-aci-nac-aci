*** Settings ***
Documentation   Verify System Perfomance
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% if apic.fabric_policies.system_performance.admin_state is defined %}
Verify System Perfomance
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/comm-default/apiResp.json
    Should Be Equal Value Json String   ${r.json()}    $..commApiRespTime.attributes.enableCalculation   {{ apic.fabric_policies.system_performance.admin_state | default(defaults.apic.fabric_policies.system_performance.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commApiRespTime.attributes.respTimeThreshold   {{ apic.fabric_policies.system_performance.response_threshold | default(defaults.apic.fabric_policies.system_performance.response_threshold) }}
    Should Be Equal Value Json String   ${r.json()}    $..commApiRespTime.attributes.topNRequests   {{ apic.fabric_policies.system_performance.top_slowest_requests | default(defaults.apic.fabric_policies.system_performance.top_slowest_requests) }}
    Should Be Equal Value Json String   ${r.json()}    $..commApiRespTime.attributes.calcWindow   {{ apic.fabric_policies.system_performance.calculation_window | default(defaults.apic.fabric_policies.system_performance.calculation_window ) }}
{% endif %}