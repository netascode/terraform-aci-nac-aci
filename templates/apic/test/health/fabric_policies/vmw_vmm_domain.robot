*** Settings ***
Documentation   Verify VMware VMM Domain Health
Suite Setup     Login APIC
Default Tags    apic   day1   health   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% set vmm_name = vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}

Verify VMware VMM Domain {{ vmm_name }} Faults
    ${r}=   GET On Session   apic   /api/mo/uni/vmmp-VMware/dom-{{ vmm_name }}/fltCnts.json
    ${critical}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.crit
    ${major}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.maj
    ${minor}=   Get Value From Json   ${r.json()}   $..faultCounts.attributes.minor
    Run Keyword If   ${critical}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vmm_name }} has ${critical}[0] critical faults"
    Run Keyword If   ${major}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vmm_name }} has ${major}[0] major faults"
    Run Keyword If   ${minor}[0] > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ vmm_name }} has ${minor}[0] minor faults"

{% endfor %}
