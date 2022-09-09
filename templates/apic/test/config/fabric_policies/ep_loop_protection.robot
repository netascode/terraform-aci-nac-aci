*** Settings ***
Documentation   Verify EP Loop Protection
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify EP Loop Protection
    ${r}=   GET On Session   apic   /api/mo/uni/infra/epLoopProtectP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..epLoopProtectP.attributes.action   {{ apic.fabric_policies.ep_loop_protection.action | default(defaults.apic.fabric_policies.ep_loop_protection.action) }}
    Should Be Equal Value Json String   ${r.json()}    $..epLoopProtectP.attributes.adminSt   {{ apic.fabric_policies.ep_loop_protection.admin_state | default(defaults.apic.fabric_policies.ep_loop_protection.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..epLoopProtectP.attributes.loopDetectIntvl   {{ apic.fabric_policies.ep_loop_protection.detection_interval | default(defaults.apic.fabric_policies.ep_loop_protection.detection_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..epLoopProtectP.attributes.loopDetectMult   {{ apic.fabric_policies.ep_loop_protection.detection_multiplier | default(defaults.apic.fabric_policies.ep_loop_protection.detection_multiplier) }}
