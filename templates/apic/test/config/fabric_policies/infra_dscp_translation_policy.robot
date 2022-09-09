*** Settings ***
Documentation   Verify APIC Infra DSCP Translation Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify APIC Infra DSCP Translation Policy
    ${r}=   GET On Session   apic   /api/mo/uni/tn-infra/dscptranspol-default.json
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.adminSt   {{ apic.fabric_policies.infra_dscp_translation_policy.admin_state | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.control   {{ apic.fabric_policies.infra_dscp_translation_policy.control_plane | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.control_plane) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level1   {{ apic.fabric_policies.infra_dscp_translation_policy.level_1 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_1) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level2   {{ apic.fabric_policies.infra_dscp_translation_policy.level_2 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_2) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level3   {{ apic.fabric_policies.infra_dscp_translation_policy.level_3 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_3) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level4   {{ apic.fabric_policies.infra_dscp_translation_policy.level_4 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_4) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level5   {{ apic.fabric_policies.infra_dscp_translation_policy.level_5 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_5) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.level6   {{ apic.fabric_policies.infra_dscp_translation_policy.level_6 | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.level_6) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.policy   {{ apic.fabric_policies.infra_dscp_translation_policy.policy_plane | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.policy_plane) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.span   {{ apic.fabric_policies.infra_dscp_translation_policy.span | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.span) }}
    Should Be Equal Value Json String   ${r.json()}    $..qosDscpTransPol.attributes.traceroute   {{ apic.fabric_policies.infra_dscp_translation_policy.traceroute | default(defaults.apic.fabric_policies.infra_dscp_translation_policy.traceroute) }}
