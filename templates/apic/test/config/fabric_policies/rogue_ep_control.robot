*** Settings ***
Documentation   Verify Rogue EP Control
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Rogue EP Control
    ${r}=   GET On Session   apic   /api/mo/uni/infra/epCtrlP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..epControlP.attributes.adminSt   {{ apic.fabric_policies.rogue_ep_control.admin_state | default(defaults.apic.fabric_policies.rogue_ep_control.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..epControlP.attributes.holdIntvl   {{ apic.fabric_policies.rogue_ep_control.hold_interval | default(defaults.apic.fabric_policies.rogue_ep_control.hold_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..epControlP.attributes.rogueEpDetectIntvl   {{ apic.fabric_policies.rogue_ep_control.detection_interval | default(defaults.apic.fabric_policies.rogue_ep_control.detection_interval) }}
    Should Be Equal Value Json String   ${r.json()}    $..epControlP.attributes.rogueEpDetectMult   {{ apic.fabric_policies.rogue_ep_control.detection_multiplier | default(defaults.apic.fabric_policies.rogue_ep_control.detection_multiplier) }}
