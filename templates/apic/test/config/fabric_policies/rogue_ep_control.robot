*** Settings ***
Documentation   Verify Rogue EP Control
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Rogue EP Control
    GET   "/api/mo/uni/infra/epCtrlP-default.json"
    String   $..epControlP.attributes.adminSt   {{ apic.fabric_policies.rogue_ep_control.admin_state | default(defaults.apic.fabric_policies.rogue_ep_control.admin_state) | cisco.aac.aac_bool("enabled") }}
    String   $..epControlP.attributes.holdIntvl   {{ apic.fabric_policies.rogue_ep_control.hold_interval | default(defaults.apic.fabric_policies.rogue_ep_control.hold_interval) }}
    String   $..epControlP.attributes.rogueEpDetectIntvl   {{ apic.fabric_policies.rogue_ep_control.detection_interval | default(defaults.apic.fabric_policies.rogue_ep_control.detection_interval) }}
    String   $..epControlP.attributes.rogueEpDetectMult   {{ apic.fabric_policies.rogue_ep_control.detection_multiplier | default(defaults.apic.fabric_policies.rogue_ep_control.detection_multiplier) }}
