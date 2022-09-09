*** Settings ***
Documentation   Verify Port Tracking
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Port Tracking
    ${r}=   GET On Session   apic   /api/mo/uni/infra/trackEqptFabP-default.json
    Should Be Equal Value Json String   ${r.json()}    $..infraPortTrackPol.attributes.adminSt   {{ apic.fabric_policies.port_tracking.admin_state | default(defaults.apic.fabric_policies.port_tracking.admin_state) | cisco.aac.aac_bool("on") }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortTrackPol.attributes.delay   {{ apic.fabric_policies.port_tracking.delay | default(defaults.apic.fabric_policies.port_tracking.delay) }}
    Should Be Equal Value Json String   ${r.json()}    $..infraPortTrackPol.attributes.minlinks   {{ apic.fabric_policies.port_tracking.min_links | default(defaults.apic.fabric_policies.port_tracking.min_links) }}
