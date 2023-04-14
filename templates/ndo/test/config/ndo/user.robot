*** Settings ***
Documentation   Verify User
Suite Setup     Login NDO
Default Tags    ndo   config   day0
Resource        ../../ndo_common.resource

*** Test Cases ***
Get Users
    ${r}=   GET On Session   ndo   /api/v1/users
    Set Suite Variable   ${r}

{% for user in ndo.users | default([]) %}

Verify User {{ user.username }}
    ${user}=   Set Variable   $..users[?(@.username=='{{ user.username }}')]
    Should Be Equal Value Json String   ${r.json()}   ${user}.username   {{ user.username }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.firstName   {{ user.first_name }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.lastName   {{ user.last_name }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.emailAddress   {{ user.email_address }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.phoneNumber   {{ user.phone_number | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${user}.accountStatus   {{ user.status | default(defaults.ndo.users.status) }}

{% endfor %}
