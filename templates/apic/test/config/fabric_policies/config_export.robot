*** Settings ***
Documentation   Verify Config Exports
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.config_exports | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.config_exports.name_suffix %}

Verify Config Export {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/configexp-{{ policy_name }}.json   params=rsp-subtree=full
    Should Be Equal Value Json String   ${r.json()}    $..configExportP.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..configExportP.attributes.descr   {{ policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..configExportP.attributes.format   {{ policy.format | default(defaults.apic.fabric_policies.config_exports.format) }}
    Should Be Equal Value Json String   ${r.json()}    $..configExportP.attributes.snapshot   {{ policy.snapshot | default(defaults.apic.fabric_policies.config_exports.snapshot) | cisco.aac.aac_bool("yes") }}
{% if policy.remote_location is defined %}
{% set rl_name = policy.remote_location ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..configRsRemotePath.attributes.tnFileRemotePathName   {{ rl_name }}
{% endif %}  
{% if policy.scheduler is defined %}
{% set scheduler_name = policy.scheduler ~ defaults.apic.fabric_policies.schedulers.name_suffix %}
    Should Be Equal Value Json String   ${r.json()}    $..configRsExportScheduler.attributes.tnTrigSchedPName   {{ scheduler_name }}
{% endif %}  

{% endfor %}
