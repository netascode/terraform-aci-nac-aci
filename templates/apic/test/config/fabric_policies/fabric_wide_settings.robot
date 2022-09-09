*** Settings ***
Documentation   Verify Fabric Wide Settings
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Fabric Wide Settings
    ${r}=   GET On Session   apic   /api/mo/uni/infra/settings.json
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.domainValidation   {{ apic.fabric_policies.global_settings.domain_validation | default(defaults.apic.fabric_policies.global_settings.domain_validation) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.enforceSubnetCheck   {{ apic.fabric_policies.global_settings.enforce_subnet_check | default(defaults.apic.fabric_policies.global_settings.enforce_subnet_check) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.opflexpAuthenticateClients   {{ apic.fabric_policies.global_settings.opflex_authentication | default(defaults.apic.fabric_policies.global_settings.opflex_authentication) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.unicastXrEpLearnDisable   {{ apic.fabric_policies.global_settings.disable_remote_endpoint_learn | default(defaults.apic.fabric_policies.global_settings.disable_remote_endpoint_learn) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.validateOverlappingVlans   {{ apic.fabric_policies.global_settings.overlapping_vlan_validation | default(defaults.apic.fabric_policies.global_settings.overlapping_vlan_validation) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.enableRemoteLeafDirect   {{ apic.fabric_policies.global_settings.remote_leaf_direct | default(defaults.apic.fabric_policies.global_settings.remote_leaf_direct) | cisco.aac.aac_bool("yes") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraSetPol.attributes.reallocateGipo   {{ apic.fabric_policies.global_settings.reallocate_gipo | default(defaults.apic.fabric_policies.global_settings.reallocate_gipo) | cisco.aac.aac_bool("yes") }}
