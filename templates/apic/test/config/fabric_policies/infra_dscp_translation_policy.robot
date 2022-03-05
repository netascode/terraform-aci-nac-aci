*** Settings ***
Documentation   Verify APIC Infra DSCP Translation Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify APIC Infra DSCP Translation Policy
    GET   "/api/mo/uni/tn-infra/dscptranspol-default.json"
    String   $..qosDscpTransPol.attributes.adminSt   {{ apic.fabric_policies.infra_dscp_translation_policy.admin_state | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   $..qosDscpTransPol.attributes.control   {{ apic.fabric_policies.infra_dscp_translation_policy.control_plane | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.control_plane) }}
    String   $..qosDscpTransPol.attributes.level1   {{ apic.fabric_policies.infra_dscp_translation_policy.level_1 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_1) }}
    String   $..qosDscpTransPol.attributes.level2   {{ apic.fabric_policies.infra_dscp_translation_policy.level_2 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_2) }}
    String   $..qosDscpTransPol.attributes.level3   {{ apic.fabric_policies.infra_dscp_translation_policy.level_3 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_3) }}
    String   $..qosDscpTransPol.attributes.level4   {{ apic.fabric_policies.infra_dscp_translation_policy.level_4 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_4) }}
    String   $..qosDscpTransPol.attributes.level5   {{ apic.fabric_policies.infra_dscp_translation_policy.level_5 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_5) }}
    String   $..qosDscpTransPol.attributes.level6   {{ apic.fabric_policies.infra_dscp_translation_policy.level_6 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_6) }}
    String   $..qosDscpTransPol.attributes.policy   {{ apic.fabric_policies.infra_dscp_translation_policy.policy_plane | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.policy_plane) }}
    String   $..qosDscpTransPol.attributes.span   {{ apic.fabric_policies.infra_dscp_translation_policy.span | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.span) }}
    String   $..qosDscpTransPol.attributes.traceroute   {{ apic.fabric_policies.infra_dscp_translation_policy.traceroute | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.traceroute) }}
