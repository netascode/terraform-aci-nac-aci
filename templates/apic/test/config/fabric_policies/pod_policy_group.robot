*** Settings ***
Documentation   Verify Pod Policy Group
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for pg in apic.fabric_policies.pod_policy_groups | default([]) %}
{% set pod_policy_group_name = pg.name ~ defaults.apic.fabric_policies.pod_policy_groups.name_suffix %}

Verify Pod Policy Group {{ pod_policy_group_name }}
    GET   "/api/mo/uni/fabric/funcprof/podpgrp-{{ pod_policy_group_name }}.json?rsp-subtree=full"
    String   $..fabricPodPGrp.attributes.name   {{ pod_policy_group_name }}
{% if pg.snmp_policy is defined %}
{% set snmp_policy_name = pg.snmp_policy ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix %}
    String   $..fabricRsSnmpPol.attributes.tnSnmpPolName   {{ snmp_policy_name }}
{% endif %}
{% if pg.date_time_policy is defined %}
{% set date_time_policy_name = pg.date_time_policy ~ defaults.apic.fabric_policies.pod_policies.date_time_policies.name_suffix %}
    String   $..fabricRsTimePol.attributes.tnDatetimePolName   {{ date_time_policy_name }}
{% endif %}
{% if pg.management_access_policy is defined %}
{% set management_access_policy_name = pg.management_access_policy ~ defaults.apic.fabric_policies.pod_policies.management_access_policies.name_suffix %}
    String   $..fabricRsCommPol.attributes.tnCommPolName   {{ management_access_policy_name }}
{% endif %}

{% endfor %}
