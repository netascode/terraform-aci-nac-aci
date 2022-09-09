*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections

*** Variables ***
${login_json}   {"aaaUser" : {"attributes" : {"name" : "%{APIC_TEST_USERNAME}", "pwd" : "%{APIC_TEST_PASSWORD}"}}}

*** Keywords ***
Get APIC Token
    Create Session   login   https://%{APIC_TEST_HOSTNAME_IP}
    ${response}=   POST On Session   login   /api/aaaLogin.json   data=${login_json}
    ${r_token}=   Get Value From Json   ${response.json()}   $..token
    Set Parallel Value For Key   apic_token   ${r_token[0]}
    Set Suite Variable   ${apic_token}   ${r_token[0]}

Login APIC
    Wait Until Keyword Succeeds   5x   1 s   Acquire Lock   login
    ${apic_token}=   Get Parallel Value For Key   apic_token
    Run Keyword If   "${apic_token}"=="${EMPTY}"   Get APIC Token
    Release Lock   login
    Create Session   apic   https://%{APIC_TEST_HOSTNAME_IP}   headers={"Cookie": "APIC-cookie=${apic_token}"}

Should Be Equal Value Json String
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings   ${r_value}[0]   ${value}

Should Be Equal Value Json List
    [Arguments]    ${json}    ${json_path}   ${value}=${None}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${None}"   Lists Should Be Equal   ${r_value}   ${value}   ignore_order=True