*** Settings ***
Documentation   Verify BFD Switch Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   access_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for policy in apic.access_policies.switch_policies.bfd_ipv4_policies | default([]) %}
{% set bfd_ipv4_policy_name = policy.name ~ defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.name_suffix %}

Verify BFD IPv4 Switch Policy {{ bfd_ipv4_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/bfdIpv4Inst-{{ bfd_ipv4_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.name   {{ bfd_ipv4_policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.descr   {{ policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.detectMult   {{ policy.detection_multiplier | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.detection_multiplier) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.minTxIntvl   {{ policy.min_transmit_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.min_transmit_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.minRxIntvl   {{ policy.min_receive_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.min_receive_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.slowIntvl    {{ policy.slow_timer_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.slow_timer_interval) }}
    {% if policy.startup_timer_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.startupIntvl   {{ policy.startup_timer_interval }}
    {% endif %}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.echoRxIntvl   {{ policy.echo_receive_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.echo_receive_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv4InstPol.attributes.echoSrcAddr   {{ policy.echo_frame_source_address | default(defaults.apic.access_policies.switch_policies.bfd_ipv4_policies.echo_frame_source_address) }}

{% endfor %}

{% for policy in apic.access_policies.switch_policies.bfd_ipv6_policies | default([]) %}
{% set bfd_ipv6_policy_name = policy.name ~ defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.name_suffix %}

Verify BFD IPv6 Switch Policy {{ bfd_ipv6_policy_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/infra/bfdIpv6Inst-{{ bfd_ipv6_policy_name }}.json
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.name   {{ bfd_ipv6_policy_name }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.descr   {{ policy.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.detectMult   {{ policy.detection_multiplier | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.detection_multiplier) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.minTxIntvl   {{ policy.min_transmit_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.min_transmit_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.minRxIntvl   {{ policy.min_receive_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.min_receive_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.slowIntvl    {{ policy.slow_timer_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.slow_timer_interval) }}
    {% if policy.startup_timer_interval is defined %}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.startupIntvl   {{ policy.startup_timer_interval }}
    {% endif %}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.echoRxIntvl   {{ policy.echo_receive_interval | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.echo_receive_interval) }}
    Should Be Equal Value Json String   ${r.json()}   $..bfdIpv6InstPol.attributes.echoSrcAddr   {{ policy.echo_frame_source_address | default(defaults.apic.access_policies.switch_policies.bfd_ipv6_policies.echo_frame_source_address) }}

{% endfor %}