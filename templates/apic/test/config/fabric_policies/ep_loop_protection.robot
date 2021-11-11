*** Settings ***
Documentation   Verify EP Loop Protection
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify EP Loop Protection
    GET   "/api/mo/uni/infra/epLoopProtectP-default.json"
    String   $..epLoopProtectP.attributes.action   {{ apic.fabric_policies.ep_loop_protection.action | default(defaults.apic.fabric_policies.ep_loop_protection.action) }}
    String   $..epLoopProtectP.attributes.adminSt   {{ apic.fabric_policies.ep_loop_protection.admin_state | default(defaults.apic.fabric_policies.ep_loop_protection.admin_state) }}
    String   $..epLoopProtectP.attributes.loopDetectIntvl   {{ apic.fabric_policies.ep_loop_protection.detection_interval | default(defaults.apic.fabric_policies.ep_loop_protection.detection_interval) }}
    String   $..epLoopProtectP.attributes.loopDetectMult   {{ apic.fabric_policies.ep_loop_protection.detection_multiplier | default(defaults.apic.fabric_policies.ep_loop_protection.detection_multiplier) }}
