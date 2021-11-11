*** Settings ***
Documentation   Verify User
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get Users
    GET   "/api/v1/users"

{% for user in mso.users | default([]) %}

Verify User {{ user.username }}
    ${user}=   Set Variable   $..users[?(@.username=='{{ user.username }}')]
    String   ${user}.username   {{ user.username }}
    String   ${user}.firstName   {{ user.first_name }}
    String   ${user}.lastName   {{ user.last_name }}
    String   ${user}.emailAddress   {{ user.email_address }}
    String   ${user}.phoneNumber   {{ user.phone_number | default() }}
    String   ${user}.accountStatus   {{ user.status | default(defaults.mso.users.status) }}

{% endfor %}
