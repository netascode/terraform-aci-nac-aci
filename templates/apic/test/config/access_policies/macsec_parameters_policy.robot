*** Settings ***
Documentation   Verify MACsec Parameters Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.interface_policies.macsec_parameters_policies | default([]) %}
{% set policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.macsec_parameters_policies.name_suffix %}

Verify MACsec Parameters Policy {{ policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/macsecpcont/paramp-{{ policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.name   {{ policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.descr   {{ policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.cipherSuite   {{ policy.cipher_suite | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.cipher_suite) }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.confOffset   {{ policy.confidentiality_offset | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.confidentiality_offset) }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.keySvrPrio   {{ policy.key_server_priority | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.key_server_priority) }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.replayWindow   {{  policy.window_size | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.window_size) }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.sakExpiryTime   {{ policy.key_expiry_time | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.key_expiry_time) }}
    Should Be Equal Value Json String   ${r.json()}    $..macsecParamPol.attributes.secPolicy   {{ policy.security_policy | default(defaults.apic.access_policies.interface_policies.macsec_parameters_policies.security_policy) }}

{% endfor %}
