*** Settings ***
Documentation   Verify Storm Control Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% macro get_float_rate(rate) %}
    {{ (rate | string).split('.')[0] ~ '.000000' | default(rate) }}
{% endmacro %}

{% for policy in apic.access_policies.interface_policies.storm_control_policies | default([]) %}
{% set storm_control_policy_name = policy.name ~ defaults.apic.access_policies.interface_policies.storm_control_policies.name_suffix %}

Verify Storm Control Policy {{ storm_control_policy_name }}
    GET   "/api/mo/uni/infra/stormctrlifp-{{ storm_control_policy_name }}.json"
    String   $..stormctrlIfPol.attributes.name   {{ storm_control_policy_name }}
    String   $..stormctrlIfPol.attributes.nameAlias   {{ policy.alias | default() }}
    String   $..stormctrlIfPol.attributes.descr   {{ policy.description | default() }}
    String   $..stormctrlIfPol.attributes.stormCtrlAction   {{ policy.action | default(defaults.apic.access_policies.interface_policies.storm_control_policies.action) }}
    String   $..stormctrlIfPol.attributes.bcBurstPps   {{ policy.broadcast_burst_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_burst_pps) }}
    String   $..stormctrlIfPol.attributes.bcBurstRate   {{get_float_rate(policy.broadcast_burst_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_burst_rate)) }}
    String   $..stormctrlIfPol.attributes.bcRate   {{ get_float_rate(policy.broadcast_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_rate)) }}
    String   $..stormctrlIfPol.attributes.bcRatePps   {{ policy.broadcast_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.broadcast_pps) }}
    String   $..stormctrlIfPol.attributes.mcBurstPps   {{ policy.multicast_burst_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_burst_pps) }}   
    String   $..stormctrlIfPol.attributes.mcBurstRate   {{ get_float_rate(policy.multicast_burst_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_burst_rate)) }}  
    String   $..stormctrlIfPol.attributes.mcRate   {{ get_float_rate(policy.multicast_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_rate)) }}
    String   $..stormctrlIfPol.attributes.mcRatePps   {{ policy.multicast_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.multicast_pps) }}
    String   $..stormctrlIfPol.attributes.uucBurstPps   {{ policy.unknown_unicast_burst_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_burst_pps) }}
    String   $..stormctrlIfPol.attributes.uucBurstRate   {{ get_float_rate(policy.unknown_unicast_burst_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_burst_rate)) }}
    String   $..stormctrlIfPol.attributes.uucRate   {{ get_float_rate(policy.unknown_unicast_rate | default(defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_rate)) }}
    String   $..stormctrlIfPol.attributes.uucRatePps   {{ policy.unknown_unicast_pps | default(defaults.apic.access_policies.interface_policies.storm_control_policies.unknown_unicast_pps) }}

{% endfor %}
