*** Settings ***
Documentation   Verify Pod Setup
Suite Setup     Login APIC
Default Tags    apic   day1   config   pod_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pod in apic.pod_policies.pods | default([]) %}

Verify Pod {{ pod.id }} Setup
    ${r}=   GET On Session   apic   /api/mo/uni/controller/setuppol/setupp-{{ pod.id }}.json
    Should Be Equal Value Json String   ${r.json()}    $..fabricSetupP.attributes.podId   {{ pod.id }}
{% if pod.id != 1 %}
    Should Be Equal Value Json String   ${r.json()}    $..fabricSetupP.attributes.tepPool   {{ pod.tep_pool }}
{% endif %}

{% endfor %}
