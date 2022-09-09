*** Settings ***
Documentation   Verify Config Export Operational State
Suite Setup     Login APIC
Default Tags    apic   day0   operational   fabric_policies   non-critical
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.config_exports | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.config_exports.name_suffix %}

Verify Config Export {{ policy_name }} Job Status
    ${r}=   GET On Session   apic   /api/mo/uni/backupst/jobs-[uni/fabric/configexp-{{ policy_name }}].json   params=rsp-subtree=full
    ${jobs}=   Get Value From Json   ${r.json()}   $..configJobCont.children
    FOR   ${job}   IN   @{jobs}
        ${state}=   Get Value From Json   ${r.json()}   ${job}..configJob.attributes.operSt
        Run Keyword If   ${state} != "success"   Run Keyword And Continue On Failure
        ...   Fail  "Export Policy {{ policy_name }}: Job ${job}..configJob.attributes.name not successful"
    END

{% endfor %}
