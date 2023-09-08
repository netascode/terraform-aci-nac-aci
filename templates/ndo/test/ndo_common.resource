*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem
Library   ./lib/Ndo.py   %{MSO_URL}   %{MSO_USERNAME}   %{MSO_PASSWORD}

*** Variables ***
${login_json}   {"username" : "%{MSO_USERNAME}", "password" : "%{MSO_PASSWORD}"}
${state_path}   tests/state/

*** Keywords ***
Get NDO Token
    Create Session   login   %{MSO_URL}   headers={"Content-Type": "application/json"}
    ${log_level}=   Set Log Level   NONE
    ${response}=   POST On Session   login   /api/v1/auth/login   data=${login_json}
    Set Log Level   ${log_level}
    ${r_token}=   Get Value From Json   ${response.json()}   $..token
    Set Parallel Value For Key   ndo_token   ${r_token[0]}
    Set Suite Variable   ${ndo_token}   ${r_token[0]}

Login NDO
    Wait Until Keyword Succeeds   10x   1 s   Acquire Lock   login
    ${ndo_token}=   Get Parallel Value For Key   ndo_token
    Run Keyword If   "${ndo_token}"=="${EMPTY}"   Get NDO Token
    Release Lock   login
    Create Session   ndo   %{MSO_URL}   headers={"Content-Type": "application/json", "Authorization": "Bearer ${ndo_token}"}
    Set Global Variable   ${STATE_PATH}   ${state_path}

Should Be Equal Value Json String
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}   ${value2}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}" and "${value2}" == "${EMPTY}"   Should Be Equal As Strings   ${r_value}[0]   ${value}
    Run Keyword If   "${value}" != "${EMPTY}" and "${value2}" != "${EMPTY}"   Should Be True   "${r_value}[0]" == "${value}" or "${r_value}[0]" == "${value2}"

Should Be Equal Value Json Boolean
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    ${b_r_value}=   Convert To Boolean   ${r_value}[0]
    ${b_value}=   Convert To Boolean   ${value}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal   ${b_r_value}   ${b_value}

Should Be Equal Value Json Integer
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Integers   ${r_value}[0]   ${value}

Should Be Equal Value Json Number
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Numbers   ${r_value}[0]   ${value}

Should Be Equal Value Json List
    [Arguments]    ${json}    ${json_path}   ${value}=${None}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   ${value} != "${None}"   Lists Should Be Equal   ${r_value}[0]   ${value}   ignore_order=True