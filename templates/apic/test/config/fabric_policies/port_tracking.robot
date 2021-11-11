*** Settings ***
Documentation   Verify Port Tracking
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Port Tracking
    GET   "/api/mo/uni/infra/trackEqptFabP-default.json"
    String   $..infraPortTrackPol.attributes.adminSt   {{ apic.fabric_policies.port_tracking.admin_state | default(defaults.apic.fabric_policies.port_tracking.admin_state) }}
    String   $..infraPortTrackPol.attributes.delay   {{ apic.fabric_policies.port_tracking.delay | default(defaults.apic.fabric_policies.port_tracking.delay) }}
    String   $..infraPortTrackPol.attributes.minlinks   {{ apic.fabric_policies.port_tracking.min_links | default(defaults.apic.fabric_policies.port_tracking.min_links) }}
