*** Settings ***
Documentation   Verify Schedulers
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for scheduler in apic.fabric_policies.schedulers | default([]) %}
{% set scheduler_name = scheduler.name ~ defaults.apic.fabric_policies.schedulers.name_suffix %}

Verify Scheduler {{ scheduler_name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/schedp-{{ scheduler_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..trigSchedP.attributes.name   {{ scheduler_name }}
    Should Be Equal Value Json String   ${r.json()}    $..trigSchedP.attributes.descr   {{ scheduler.description | default() }}

{% for win in scheduler.recurring_windows | default([]) %}
{% set win_name = win.name ~ defaults.apic.fabric_policies.schedulers.recurring_windows.name_suffix %}

Verify Scheduler {{ scheduler_name }} Window {{ win_name }}
    ${win}=   Set Variable   $..trigSchedP.children[?(@.trigRecurrWindowP.attributes.name=='{{ win_name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${win}..trigRecurrWindowP.attributes.name   {{ win_name }}
    Should Be Equal Value Json String   ${r.json()}    ${win}..trigRecurrWindowP.attributes.day   {{ win.day | default(defaults.apic.fabric_policies.schedulers.recurring_windows.day) }}
    Should Be Equal Value Json String   ${r.json()}    ${win}..trigRecurrWindowP.attributes.hour   {{ win.hour | default(defaults.apic.fabric_policies.schedulers.recurring_windows.hour) }}
    Should Be Equal Value Json String   ${r.json()}    ${win}..trigRecurrWindowP.attributes.minute   {{ win.minute | default(defaults.apic.fabric_policies.schedulers.recurring_windows.minute) }}

{% endfor %}

{% endfor %}
