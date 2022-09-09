*** Settings ***
Documentation   Verify Forwarding Scale Switch Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.switch_policies.forwarding_scale_policies | default([]) %}
{% set forwarding_scale_policy_name = policy.name ~ defaults.apic.access_policies.switch_policies.forwarding_scale_policies.name_suffix %}

Verify Forwarding Scale Switch Policy {{forwarding_scale_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/fwdscalepol-{{forwarding_scale_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..topoctrlFwdScaleProfilePol.attributes.name   {{ forwarding_scale_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..topoctrlFwdScaleProfilePol.attributes.profType   {{ policy.profile | default(defaults.apic.access_policies.switch_policies.forwarding_scale_policies.profile) }}

{% endfor %}
