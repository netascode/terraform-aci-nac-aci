*** Settings ***
Documentation   Verify User
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get Users
    ${r}=   GET On Session   mso   /api/v1/users
    Set Suite Variable   ${r}

{% for user in mso.users | default([]) %}

Verify User {{ user.username }}
    ${user}=   Set Variable   $..users[?(@.username=='{{ user.username }}')]
    Should Be Equal Value Json String   ${r.json()}   ${user}.username   {{ user.username }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.firstName   {{ user.first_name }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.lastName   {{ user.last_name }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.emailAddress   {{ user.email_address }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.phoneNumber   {{ user.phone_number | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.accountStatus   {{ user.status | default(defaults.mso.users.status) }}

{% endfor %}
