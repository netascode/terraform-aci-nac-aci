{# iterate_list apic.tenants name item[2] #}
*** Settings ***
Documentation   Verify Redirect Backup Policy Health
Suite Setup     Login APIC
Default Tags    apic   day2   health   tenants   non-critical
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | community.general.json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for pol in tenant.services.redirect_backup_policies | default([]) %}
{% set pol_name = pol.name ~ defaults.apic.tenants.services.redirect_backup_policies.name_suffix %}

Verify Redirect Backup Policy {{ pol_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/svcCont/backupPol-{{ pol_name }}/fltCnts.json"
    ${critical}=   Output   $..faultCounts.attributes.crit
    ${major}=   Output   $..faultCounts.attributes.maj
    ${minor}=   Output   $..faultCounts.attributes.minor
    Run Keyword If   ${critical} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pol_name }} has ${critical} critical faults"
    Run Keyword If   ${major} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pol_name }} has ${major} major faults"
    Run Keyword If   ${minor} > 0   Run Keyword And Continue On Failure
    ...   Fail  "{{ pol_name }} has ${minor} minor faults"

{% endfor %}
