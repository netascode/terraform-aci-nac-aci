*** Settings ***
Documentation   Verify Config Exports
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.fabric_policies.config_exports | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.fabric_policies.config_exports.name_suffix %}

Verify Config Export {{ policy_name }}
    GET   "/api/mo/uni/fabric/configexp-{{ policy_name }}.json?rsp-subtree=full"
    String   $..configExportP.attributes.name   {{ policy_name }}
    String   $..configExportP.attributes.descr   {{ policy.description | default() }}
    String   $..configExportP.attributes.format   {{ policy.format | default(defaults.apic.fabric_policies.config_exports.format) }}
{% if policy.remote_location is defined %}
{% set rl_name = policy.remote_location ~ defaults.apic.fabric_policies.remote_locations.name_suffix %}
    String   $..configRsRemotePath.attributes.tnFileRemotePathName   {{ rl_name }}
{% endif %}  
{% if policy.scheduler is defined %}
{% set scheduler_name = policy.scheduler ~ defaults.apic.fabric_policies.schedulers.name_suffix %}
    String   $..configRsExportScheduler.attributes.tnTrigSchedPName   {{ scheduler_name }}
{% endif %}  

{% endfor %}
