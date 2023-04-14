*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections

*** Variables ***
${login_json}   {"username" : "%{MSO_USERNAME}", "password" : "%{MSO_PASSWORD}"}

*** Keywords ***
Get NDO Token
    Create Session   login   %{MSO_URL}   headers={"Content-Type": "application/json"}
    ${response}=   POST On Session   login   /api/v1/auth/login   data=${login_json}
    ${r_token}=   Get Value From Json   ${response.json()}   $..token
    Set Suite Variable   ${ndo_token}   ${r_token[0]}

Login NDO
    ${ndo_token}=   Get Variable Value   ${token}
    Run Keyword If   '${ndo_token}' == 'None'   Get NDO Token
    Create Session   ndo   %{MSO_URL}   headers={"Content-Type": "application/json", "Authorization": "Bearer ${ndo_token}"}

Should Be Equal Value Json String
    [Arguments]    ${json}    ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings   ${r_value}[0]   ${value}

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
    Run Keyword If   ${value} != "${None}"   Lists Should Be Equal   ${r_value}[0]   ${value}