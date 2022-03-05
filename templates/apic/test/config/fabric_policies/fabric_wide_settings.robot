*** Settings ***
Documentation   Verify Fabric Wide Settings
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Fabric Wide Settings
    GET   "/api/mo/uni/infra/settings.json"
    String   $..infraSetPol.attributes.domainValidation   {{ apic.fabric_policies.global_settings.domain_validation | default(defaults.apic.fabric_policies.global_settings.domain_validation) | cisco.aac.aac_bool("yes") }}
    String   $..infraSetPol.attributes.enforceSubnetCheck   {{ apic.fabric_policies.global_settings.enforce_subnet_check | default(defaults.apic.fabric_policies.global_settings.enforce_subnet_check) | cisco.aac.aac_bool("yes") }}
    String   $..infraSetPol.attributes.opflexpAuthenticateClients   {{ apic.fabric_policies.global_settings.opflex_authentication | default(defaults.apic.fabric_policies.global_settings.opflex_authentication) | cisco.aac.aac_bool("yes") }}
    String   $..infraSetPol.attributes.unicastXrEpLearnDisable   {{ apic.fabric_policies.global_settings.disable_remote_endpoint_learn | default(defaults.apic.fabric_policies.global_settings.disable_remote_endpoint_learn) | cisco.aac.aac_bool("yes") }}
    String   $..infraSetPol.attributes.validateOverlappingVlans   {{ apic.fabric_policies.global_settings.overlapping_vlan_validation | default(defaults.apic.fabric_policies.global_settings.overlapping_vlan_validation) | cisco.aac.aac_bool("yes") }}
    String   $..infraSetPol.attributes.enableRemoteLeafDirect   {{ apic.fabric_policies.global_settings.remote_leaf_direct | default(defaults.apic.fabric_policies.global_settings.remote_leaf_direct) | cisco.aac.aac_bool("yes") }}
